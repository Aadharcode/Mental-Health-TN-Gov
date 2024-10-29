## Features
- **Sign In**: Users can sign in using their email and password.
- **Sign Up**: Users can create an account by providing their name, email, school, and password.

### Environment Variables
Create a `.env` file in the root of the project and add the following line:
```
DB_CONNECTION=mongodb+srv://your_username:your_password@cluster0.0zinx.mongodb.net/auth
JWT_SECRET=your_jwt_secret
PORT=3000
```
