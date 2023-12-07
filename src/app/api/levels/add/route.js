import LevelServices from "@/services/firebase/LevelServices"

export async function POST(req) {
    req = await req.json()

    const addedLevel = await LevelServices.addLevel(req.level)
   
    return Response.json({ addedLevel })
}