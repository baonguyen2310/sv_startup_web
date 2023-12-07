import { doc, collection, addDoc, getDocs, query, where, getDoc, setDoc, updateDoc } from "firebase/firestore"; 
import { db } from '.'

const gamesCollectionRef = collection(db, "games")

class LevelServices {
    static async getLevelList({ gameId }) {
        //const gameDocRef = doc(gamesCollectionRef, gameId)

        //console.log(gameId)
        const q = query(collection(db, "levels"), where("gameId", "==", gameId));

        const docs = await getDocs(q);

        const levelList = []
        docs.forEach((doc) => {
            levelList.push({
                id: doc.id,
                ...doc.data()
            })
        })
        return levelList
    }

    static async addLevel(level) {
        const docRef = await addDoc(collection(db, 'levels'), level)
        return docRef
    }

    static async updateLevel(level, levelId) {
        const docRef = doc(db, "levels", levelId)
        return await updateDoc(docRef, level)
    }
}

export default LevelServices