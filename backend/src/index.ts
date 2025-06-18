import express from "express";
import dotenv from "dotenv";
import morgan from "morgan";
import bodyParser from "body-parser";
import cookieParser from "cookie-parser";
import authRouter from "./routes/auth.route";
import  vpnRouter from "./routes/vpn.route";
import ipRouter from "./routes/ip.route";
import {errorHandler} from "./utils/error-handler";
import profileRouter from "./routes/profile.route";

dotenv.config();
const app = express();

// middlewares
app.use(errorHandler);
app.use(morgan("dev"));
app.use(bodyParser.json());
app.use(cookieParser());

//routes
app.use('/api/auth', authRouter);
app.use('/api/vpn', vpnRouter);
app.use('/api/ip',ipRouter);
app.use('/api/profile', profileRouter);

app.listen(process.env.PORT, () => {
    console.log("Server listening on port: " + process.env.PORT);
});

