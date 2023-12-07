import AuthService from "@/services/firebase/AuthServices"

export async function GET() {
    const email = "testnext@gmail.com"
    const password = "testnext"

    const user = await AuthService.logout(email, password)
   
    return Response.json({ user })
}