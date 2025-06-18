import dotenv from "dotenv";
import mysql from 'mysql2/promise';
import {drizzle} from "drizzle-orm/mysql2";

dotenv.config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
});

 pool.getConnection().then((connection) => {
    console.log(`Successfully connected to MySQL database: ${process.env.DB_NAME ?? "obscureme_vpn_db"}`);
    connection.release();
});


const db = drizzle(pool);

export default db;

