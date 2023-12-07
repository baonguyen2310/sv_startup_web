import GameServices from "@/services/firebase/GameServices"

export async function GET() {
    const gameList = await GameServices.getGameList()
   
    return Response.json({ gameList })
}