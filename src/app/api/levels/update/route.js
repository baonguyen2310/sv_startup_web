import LevelServices from "@/services/firebase/LevelServices"

export async function POST(req) {
    req = await req.json()

    const addedLevel = await LevelServices.updateLevel(req.level, req.levelId)
   
    return Response.json({ addedLevel })
}