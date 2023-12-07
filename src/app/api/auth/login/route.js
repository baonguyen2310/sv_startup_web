import AuthService from "@/services/firebase/AuthServices"

export async function POST(req) {
    req = await req.json()

    const user = await AuthService.login(req.email, req.password)

    return Response.json({ user })
}