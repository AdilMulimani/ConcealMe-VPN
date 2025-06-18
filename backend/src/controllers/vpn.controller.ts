import {Request, Response} from "express";
import dotenv from "dotenv";
import {parse} from 'csv-parse/sync';


dotenv.config();

export const getAllVpnServers = async (req: Request, res: Response) => {
    try {
        const response = await fetch('https://www.vpngate.net/api/iphone/', {
            headers: { 'Accept': 'text/plain' }
        });

        if (!response.ok) {
            res.status(400).json({
                success: false,
                error: "Something went wrong. Please try again."
            });
            return;
        }

        const rawString = await response.text();
        const csvString = rawString.split('#')[1]?.replace('*', '');
        if (!csvString) {
            res.status(400).json({
                success: false,
                error: "Something went wrong. Please try again."
            });
            return;
        }

        let records = parse(csvString, {
            columns: true,
            relax_quotes: true,
            skip_empty_lines: true,
            trim: true,
        });

        records = records.map((record: any) => {
            let decodedConfig = record.OpenVPN_ConfigData_Base64
                ? Buffer.from(record.OpenVPN_ConfigData_Base64, 'base64').toString('utf-8')
                : null;

            if (decodedConfig) {
                decodedConfig = decodedConfig.replace(
                    /cipher AES-128-CBC\s*\nauth SHA1/g,
                    'data-ciphers AES-128-CBC\ndata-ciphers-fallback AES-128-CBC\nauth SHA1'
                );
            }

            // Convert speed to Mbps or Gbps
            const speedBps = parseFloat(record.Speed);
            let speed = speedBps >= 1_000_000_000
                ? `${(speedBps / 1_000_000_000).toFixed(2)} Gbps`
                : `${(speedBps / 1_000_000).toFixed(2)} Mbps`;

            return {
                ...record,
                Speed: speed,
                Ping: `${record.Ping} ms`,
                TotalTraffic: `${(record.TotalTraffic / 1_099_511_627_776).toFixed(2)} TB`,
                OpenVPN_ConfigData_Base64: undefined,
                OpenVPN_ConfigData: decodedConfig,
            };
        });
        
        res.status(200).json({ success: true, servers: records });

    } catch (error) {
        console.log("Error occurred: ", error);
        res.status(500).json({
            success: false,
            error: "Something went wrong. Please try again.",
        });
    }
};

