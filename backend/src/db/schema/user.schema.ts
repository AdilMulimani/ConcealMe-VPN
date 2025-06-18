import {mysqlTable, serial, varchar, datetime, boolean, timestamp, mysqlEnum} from "drizzle-orm/mysql-core";

//Definition of users table
export const users= mysqlTable("users",{
    id: serial("id").primaryKey(),
    name:varchar("name",{length:255}).notNull(),
    email:varchar("email",{length:255}).unique().notNull(),
    password:varchar("password",{length:255}).notNull(),
    lastLogin:timestamp("last_login").defaultNow(),
    isVerified:boolean("is_verified").default(false),
    resetPasswordToken:varchar("reset_password_token",{length:4}),
    resetPasswordExpiresAt:datetime("reset_password_expires_at"),
    isResetVerified:boolean("is_reset_verified").default(false),
    verificationToken:varchar("verification_token",{length:4}),
    verificationTokenExpiresAt:datetime("verification_token_expires_at"),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at",{}).defaultNow(),
    gender: mysqlEnum("gender", ["Male", "Female", "Other", "Not Specified"]).default("Not Specified"),

});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;