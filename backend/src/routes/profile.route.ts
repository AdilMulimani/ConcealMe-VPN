import express from "express";
import {
    deleteProfile,
    getProfile,
    updateProfile,

} from "../controllers/profile.controller";
import {verifyToken} from "../middlewares/verify-token";

const profileRouter = express.Router();

profileRouter.get('/:id',verifyToken,getProfile);
profileRouter.delete('/:id',verifyToken,deleteProfile);
profileRouter.put("/:id",verifyToken,updateProfile);



export default profileRouter;

