import {Request, Response} from 'express';
import bcrypt from 'bcryptjs';
import db from '../db/index';
import dotenv from 'dotenv';
import {isEmail, isStrongPassword} from 'validator';

import {
    AuthRequest,
    ForgotPasswordBody,
    ResetPasswordBody,
    SignInBody,
    SignUpBody,
    VerifyEmailBody,
    VerifyResetTokenBody
} from "../interfaces/auth.interface";
import {NewUser, users} from "../db/schema/user.schema";
import {and, eq, gt} from "drizzle-orm";
import {generateEmailToken} from "../utils/generate-email-token";
import {generateTokenAndSetCookie} from "../utils/generate-token-and-set-cookie";
import {
    sendPasswordResetEmail,
    sendResetSuccessEmail,
    sendVerificationEmail,
    sendWelcomeEmail
} from "../services/mail/emails";

dotenv.config();

export const signUp = async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        // Required fields from request body
        const {name, email, password} = req.body;

        // Validate required fields
        if (!name || !email || !password) {
            res.status(400).json({
                success: false,
                error: 'All the fields are required'
            });
            return;
        }

        //Check if the user already exists
        const [existingUser] = await db
            .select()
            .from(users)
            .where(eq(users.email, email))

        if (existingUser) {
            res.status(400).json({
                success: false,
                error: "Something went wrong. Please try again."
            });
            return;
        }

        // Register new User

        // Check if the fields are valid

        //Email
        if (!isEmail(email)) {
            res.status(400).json({
                success: false,
                error: "Please enter a valid email"
            });
            return;
        }

        //Password
        if (!isStrongPassword(password, {
            minLength: 8,
            minUppercase: 1,
            minNumbers: 1,
            minSymbols: 1,
        })) {
            res.status(400).json({
                success: false,
                error: "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
            });
            return;
        }

        //Encrypt user's password
        const hashedPassword = await bcrypt.hash(password, Number(process.env.SALT_FACTOR));

        // Generate Verification Token
        const verificationToken = generateEmailToken();
        const verificationTokenExpiresAt =  new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours,

        //Create local instance of user
        const newUser: NewUser = {
            email: email,
            name: name,
            password: hashedPassword,
            verificationToken: verificationToken,
            verificationTokenExpiresAt:  verificationTokenExpiresAt,
        };

        // Insert the user into database
       const [insertedUserId]  = await db.insert(users).values(newUser).$returningId();

        // Get the insertedUser from database
        const [insertedUser] = await db.select().from(users).where(eq(users.id,insertedUserId.id));

        //Generate JWT and Set Cookie
        const token = generateTokenAndSetCookie(res, String(insertedUser.id));

        //Send Verification Email
        await sendVerificationEmail(insertedUser.email, insertedUser.verificationToken!);

        res.status(201).header('x-auth-token',token).json({
            success: true,
            message: 'Signed Up Successfully!',
            ...insertedUser,
            password: undefined
        });

    } catch (error) {
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const verifyEmail = async (req: Request<{}, {}, VerifyEmailBody>, res: Response) =>  {
    try {
        // Get the token
        const {verificationToken} = req.body;

        // Validate token
        if (!verificationToken) {
            res.status(400).json({
                success: false,
                error: 'Verification Token is required'
            });
            return;
        }

        console.log(verificationToken);

        // Get the user data with verification token
        const [user] = await db
            .select()
            .from(users)
            .where(
                and(
                    eq(users.verificationToken, verificationToken),
                    gt(users.verificationTokenExpiresAt, new Date())
                )
            );

        // Invalid or Expired Token
        if (!user) {
            res.status(400).json({
                success: false,
                error: "Invalid or expired verification OTP."
            });
            return;
        }

        // Valid Token

        //Update user details
         await db.update(users)
            .set({
                verificationToken: null,
                verificationTokenExpiresAt: null,
                isVerified: true,
            })
             .where(eq(users.email, user.email));

        // Get the updated details
        const [verifiedUser] = await db.select().from(users).where(eq(users.id, user.id));

        //  Send Welcome Email
        await sendWelcomeEmail(verifiedUser.email, verifiedUser.name);

        res.status(200).json({
            success: true,
            message: 'Email Verfied Successfully!',
            ...verifiedUser,
            password: undefined
        });
    } catch (error) {
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const signIn = async (req: Request<{}, {}, SignInBody>, res: Response) => {
    try {
        // Get required fields
        const {email, password} = req.body;

        // Validate required fields
        if (!email || !password) {
            res.status(400).json({
                success: false,
                error: 'All the fields are required'
            });
            return;
        }

        if (!isEmail(email)) {
            res.status(400).json({
                success: false,
                error: "Invalid Credentials!"
            });
            return;
        }

        // Check if user exists
        const [existingUser] = await
            db
                .select()
                .from(users)
                .where(eq(users.email, email));

        if (!existingUser) {
            res.status(400).json({
                success: false,
                error: "Invalid Credentials!"
            });
            return;
        }

        // Compare the passwords
        const isMatch = await bcrypt.compare(password, existingUser.password);

        if (!isMatch) {
            res.status(400).json({
                success: false,
                error: "Invalid Credentials!"
            });
            return;
        }

        // Generate Token and Set Cookie
        const token = generateTokenAndSetCookie(res, String(existingUser.id));

        // Update last logged in
        await db
            .update(users)
            .set({
                lastLogin: new Date(),
            })
            .where(eq(users.email, existingUser.email));

        const [updatedUser] = await db.select().from(users).where(eq(users.id, existingUser.id));

        res.status(200).header('x-auth-token',token).json({
            success: true,
            message: 'Signed in Successfully!',
            ...updatedUser,
            password: undefined
        });

    } catch (error) {
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const forgotPassword = async (req: Request<{}, {}, ForgotPasswordBody>, res: Response) => {
    try {
        // Get the required fields
        const {email} = req.body;

        // Validate fields
        if (!email) {
            res.status(400).json({
                success: false,
                error: 'Email is required'
            });
            return;
        }

        if (!isEmail(email)) {
            res.status(400).json({
                success: false,
                error: "Enter a valid email address"
            });
            return;
        }

        // Check if the user exists
        const [existingUser] = await
            db
                .select()
                .from(users)
                .where(eq(users.email, email));

        if (!existingUser) {
            res.status(400).json({
                success: false,
                error: "Invalid Credentials!"
            });
            return;
        }

        // User exists

        //Generate reset token and expire data
        const resetPasswordToken = generateEmailToken();
        const resetPasswordExpiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours,

        await
            db
                .update(users)
                .set({
                    resetPasswordToken: resetPasswordToken,
                    resetPasswordExpiresAt: resetPasswordExpiresAt
                })
                .where(eq(users.email, existingUser.email));

        const [resetRequestedUser] = await db.select().from(users).where(eq(users.id, existingUser.id));


        //send reset password token in email
       await sendPasswordResetEmail(resetRequestedUser.email, resetRequestedUser.resetPasswordToken!);

        res.status(200).json({
            success: true,
            message: "Password reset OTP is sent to your email!",
        });

    } catch (error) {
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const verifyResetToken = async (req: Request<{}, {}, VerifyResetTokenBody>, res: Response) => {
    try {
        // Get required fields
        const {resetPasswordToken} = req.body;

        // Validate required fields
        if (!resetPasswordToken) {
            res.status(400).json({
                success: false,
                error: 'Token is required'
            });
            return;
        }

        // Check if the reset token matches
        const [resetRequestedUser] = await db.select().from(users).where(
           and(
                eq(users.resetPasswordToken, resetPasswordToken),
                gt(users.resetPasswordExpiresAt, new Date())
          )
    );

        // Mismatch or Expired
        if (!resetRequestedUser) {
            res.status(400).json({
                success: false,
                error: 'Invalid or expired OTP'
            });
        }

        // Set isResetVerified
        await
            db
                .update(users)
                .set({
                    isResetVerified: true
                })
                .where(eq(users.resetPasswordToken, resetPasswordToken));


        res.status(200).json({
            success: true,
            message: "Reset OTP verification successful!",
        });
    } catch (error) {
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const resetPassword = async (req: Request<{}, {}, ResetPasswordBody>, res: Response) => {
    try {
        // Get required fields
        const {password,resetPasswordToken} = req.body;

        // Validate required fields

        if (!password || !resetPasswordToken) {
            res.status(400).json({
                success: false,
                error: 'Invalid Credentials!'
            });
            return;
        }

          //Password
              if (!isStrongPassword(password, {
                  minLength: 8,
                  minUppercase: 1,
                  minNumbers: 1,
                  minSymbols: 1,
              })) {
                  res.status(400).json({
                      success: false,
                      error: "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
                  });
                  return;
              }


        // Find User with reset token
        const [user] = await db
            .select()
            .from(users)
            .where(
                and(
                    eq(users.isResetVerified,true),
                    eq(users.resetPasswordToken, resetPasswordToken),
                    gt(users.resetPasswordExpiresAt, new Date())
                ));

        //User not found
        if (!user) {
             res.status(400).json({
                success: false,
                error: "Invalid or expired reset token!"
            });
             return;
        }

        //update password after encryption
        const hashedPassword = await bcrypt.hash(password, Number(process.env.SALT_FACTOR));

        await db.update(users).set({
            isResetVerified: false,
            password: hashedPassword,
            resetPasswordExpiresAt: null,
            resetPasswordToken:null
        }).where(eq(users.resetPasswordToken, resetPasswordToken));

        //Sender reset success email
       await sendResetSuccessEmail(user.email);

        res.status(200).json({
            success: true,
            message: "Password reset successful!",
        });

    } catch (error) {
      console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const checkAuth = async (req: AuthRequest, res: Response) => {
    try{
        // Get userId from request body set by verify token middleware
        const userId = req.userId;

        // Get the details of user
        // Get user with the valid token's user id
        const [user] = await
            db.
            select().
            from(users).
            where(
                eq(users.id,userId!)
            );


        // No user found
        if(!user){
            res.status(404).json({
                success: false,
                error: "Invalid or Expired token",
            });
            return;
        }

        // Send Authenticated data
        res.status(200).json({
            success: true,
            message: "Authentication successful!",
            ...user,
            password:undefined
        });

    }catch(error){
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}

export const signOut = async (req: Request, res: Response) => {
    try {
        res.clearCookie("token");
        res.status(200).json({
            success: true,
            message: "Signed out successfully!"
        });
        return;
    } catch (error) {
        console.debug("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}