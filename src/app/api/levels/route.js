import LevelServices from "@/services/firebase/LevelServices"

export async function POST(req) {
    req = await req.json()

    const levelList = await LevelServices.getLevelList({ gameId: req.gameId })
   
    return Response.json({ levelList })
}