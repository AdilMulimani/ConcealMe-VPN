// drizzle.config.ts
import {Config, defineConfig} from 'drizzle-kit';
import dotenv from 'dotenv';
dotenv.config();

export default defineConfig({
    dialect: 'mysql',
    schema: './src/db/schema/*',
    out: './drizzle/',
    dbCredentials: {
        url: process.env.DB_URL as string,
    },
    verbose: true,
}) satisfies Config;