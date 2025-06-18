import {Request, Response} from "express";
import dotenv from "dotenv";

dotenv.config();

export const getIpDetails = async (req:Request, res:Response) => {
    try{
        const clientIp =
            req.headers['x-forwarded-for'] || req.socket.remoteAddress;
        console.log("Client IP: ", clientIp);
        const response = await fetch(`http://ip-api.com/json/${clientIp}`,{
            method: 'GET',
            headers: {'Accept': 'application/json'}
        });

        if(!response.ok){
            res.status(400).json({
                success: false,
                error: "Something went wrong. Please try again."
            });
            return;
        }

        let result = await response.json();

         res.status(200).json({result});
    }
    catch(error){
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
}