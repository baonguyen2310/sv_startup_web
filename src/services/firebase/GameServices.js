import { doc, collection, addDoc, getDocs, serverTimestamp } from "firebase/firestore"; 
import { db } from '.'

class GameServices {
    static async getGameList() {
        const docs = await getDocs(collection(db, "games"));

        const gameList = []
        docs.forEach((doc) => {
            gameList.push({
                id: doc.id,
                ...doc.data()
            })
        })
        return gameList
    }
}

export default GameServices