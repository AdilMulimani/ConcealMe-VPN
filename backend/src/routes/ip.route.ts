import express from 'express';
import {getIpDetails} from "../controllers/ip.controller";

const router = express.Router();

router.get('/',getIpDetails);

export default router;