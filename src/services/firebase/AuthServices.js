import firebaseApp from ".";
import { 
    getAuth,
    onAuthStateChanged,
    createUserWithEmailAndPassword,
    signInWithEmailAndPassword,
    signOut
} from 'firebase/auth';
import { initializeAuth } from 'firebase/auth';
const auth = initializeAuth(firebaseApp);

//const auth = getAuth(firebaseApp)

class AuthService {
    // Kiểm tra đã đăng nhập chưa
    // Check accessToken trong AsyncStorage có hợp lệ trong db không?
    static async checkLoggedIn() {
        // try {
        //     return await AsyncStorage.getItem('user')
        // } catch (error) {
        //     const errorCode = error.code;
        //     const errorMessage = error.message;
        //     //console.log(errorMessage)
        //     return null
        // }
    }

    // Đăng ký tài khoản mới
    static async register(email, password) {
        try {
            const userCredential = await createUserWithEmailAndPassword(auth, email, password)
            const user = userCredential.user.uid
            //console.log(user)
            return user
        } catch (error) {
            const errorCode = error.code;
            const errorMessage = error.message;
            switch (errorCode) {
                case "auth/email-already-in-use":
                    console.log("Email đã được sử dụng!")
                    break
                case "auth/invalid-email":
                    console.log("Email không hợp lệ!")
                    break
                case "auth/weak-password":
                    console.log("Mật khẩu phải có ít nhất 6 ký tự!")
                    break
                default:
                    alert(errorCode)
                    break
            }
            return null
        }
    }

    // Đăng nhập bằng email và mật khẩu
    static async login(email, password) {
        try {
            const userCredential = await signInWithEmailAndPassword(auth, email, password)
            const user = userCredential.user.uid
            //console.log(user)
            //await AsyncStorage.setItem('user', user)
            return user
        } catch (error) {
            const errorCode = error.code;
            const errorMessage = error.message;
            //console.log(errorMessage)
            return null
        }
    }

    // Đăng xuất
    static async logout() {
        try {
            await signOut(auth)
            //await AsyncStorage.removeItem('user')
            return
        } catch (error) {
            //console.log(error)
        }
    }
}

export default AuthService;
