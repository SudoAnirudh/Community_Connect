import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyBrDjWagSH4r2TLg5J4LSjWey-d0BUnoYk",
  projectId: "communityconnect-eb5e1",
  storageBucket: "communityconnect-eb5e1.firebasestorage.app",
};

export const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
