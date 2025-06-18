import express from 'express';
import {getAllVpnServers} from "../controllers/vpn.controller";

const router = express.Router();

router.get("/vpn-servers",getAllVpnServers);

export default router;