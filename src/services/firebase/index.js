import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore"
import { getStorage } from "firebase/storage"

const firebaseConfig = {
  apiKey: "AIzaSyBzn54Ene7yg0sNXKGRC1fbe-zst4mT6EI",
  authDomain: "sv-startup.firebaseapp.com",
  databaseURL: "https://sv-startup-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "sv-startup",
  storageBucket: "sv-startup.appspot.com",
  messagingSenderId: "779622086348",
  appId: "1:779622086348:web:4fb1daaef282bc22947469",
  measurementId: "G-PMR8712FE2"
};

const firebaseApp = initializeApp(firebaseConfig);
export const db = getFirestore(firebaseApp)
export const storage = getStorage(firebaseApp)

export default firebaseApp
