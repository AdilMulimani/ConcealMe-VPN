import { defineConfig } from "drizzle-kit";
import dotenv from "dotenv";
import path from "path";

dotenv.config({ path: path.resolve(__dirname, "../../../../.env") }); // 👈 Adjust to point to root `.env`

export default defineConfig({
  dialect: "mysql",
  schema: path.resolve(__dirname, "./schema/*.ts"),
  out: path.resolve(__dirname, "./drizzle"),
  dbCredentials: {
    url: process.env.DB_URL as string,
  },
  verbose: true,
});
