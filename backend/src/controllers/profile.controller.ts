import { Request, Response } from 'express';
import db from '../db/index';
import { users } from '../db/schema/user.schema';
import { eq } from 'drizzle-orm';
import {Gender} from "../enum/gender";


// ✅ GET /api/profile/:id
export const getProfile = async (req: Request, res: Response) => {
    const userId = parseInt(req.params.id);

    try {
        const result = await db.select()
            .from(users)
            .where(eq(users.id, userId))
            .limit(1);

        const user = result[0];

        if (!user) {
             res.status(404).json({ success: false, error: 'User not found' });
             return;
        }

        res.json({
            success: true,
            message: "User profile found!",
            _id: user.id,
            name: user.name,
            email: user.email,
            gender: user.gender,
        });
    } catch (err) {
        res.status(500).json({ success: false, error: 'Failed to fetch profile' });
    }
};

// ✅ PUT /api/profile/:id
export const updateProfile = async (req: Request, res: Response) => {
    const userId = parseInt(req.params.id);
    const { name, gender } = req.body;

    try {
        const existingUser = await db.select()
            .from(users)
            .where(eq(users.id, userId))
            .limit(1);

        if (existingUser.length === 0) {
             res.status(404).json({ success: false, error: "User not found" });
             return;
        }

        // Validate gender if provided
        if (gender && !Object.values(Gender).includes(gender)) {
             res.status(400).json({ success: false, error: "Invalid gender value" });
             return;
        }

        await db.update(users)
            .set({
                ...(name && { name }),
                ...(gender && { gender }),
                updatedAt: new Date(),
            })
            .where(eq(users.id, userId));

        const updatedUser = await db.select()
            .from(users)
            .where(eq(users.id, userId))
            .limit(1);

        const user = updatedUser[0];

        res.json({
            success: true,
            message: "Profile updated",
            _id: user.id,
            name: user.name,
            email: user.email,
            gender: user.gender,
        });
    } catch (err) {
        console.error("Profile update error:", err);
        res.status(500).json({ success: false, error: "Failed to update profile" });
    }
};

// ✅ DELETE /api/profile/:id
export const deleteProfile = async (req: Request, res: Response) => {
    const userId = parseInt(req.params.id);

    try {
        const existingUser = await db.select()
            .from(users)
            .where(eq(users.id, userId))
            .limit(1);

        if (existingUser.length === 0) {
             res.status(404).json({ success: false, error: "User not found" });
             return;
        }

        await db.delete(users).where(eq(users.id, userId));

        const user = existingUser[0];

        res.json({
            success: true,
            message: "User deleted successfully",
            _id: user.id,
            name: user.name,
            email: user.email,
            gender: user.gender,
        });
    } catch (err) {
        console.error("Error deleting user:", err);
        res.status(500).json({ success: false, error: "Failed to delete user" });
    }
};
