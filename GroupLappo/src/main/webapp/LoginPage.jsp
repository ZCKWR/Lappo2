<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Lappo</title>
    <!-- Link to your custom CSS if you have specific styles like the top-right button -->
    <link rel="stylesheet" type="text/css" href="Login.css">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'primary': '#0d9488', /* Student Teal */
                        'primary-dark': '#0f766e', /* Darker Teal */
                    }
                }
            }
        }
    </script>
    
    <style>
        /* Embedding necessary styles for the top-right button/card if Login.css is missing */
        body {
            background-color: #f3f4f6; /* Light gray background like Tailwind default */
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .login-card {
            background-color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            position: relative; /* For absolute positioning of the back button */
            border-top: 4px solid #0d9488; /* Teal accent border */
        }

        /* Container for the back button */
        .top-right-button-container {
            position: absolute;
            top: 1rem;
            right: 1rem;
        }

        .top-right-button {
            background: transparent;
            border: 1px solid #d1d5db;
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            color: #6b7280;
            cursor: pointer;
            transition: all 0.2s;
        }

        .top-right-button:hover {
            background-color: #f3f4f6;
            color: #374151;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem; /* p-3 */
            border: 1px solid #d1d5db; /* border-gray-300 */
            border-radius: 0.5rem; /* rounded-lg */
            margin-top: 0.25rem;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #0d9488; /* focus:ring-primary (Teal) */
            box-shadow: 0 0 0 3px rgba(13, 148, 136, 0.1); /* Teal shadow */
        }

        .form-button {
            width: 100%;
            background-color: #0d9488; /* bg-primary (Teal) */
            color: white;
            font-weight: 600; /* font-semibold */
            padding: 0.75rem; /* py-3 */
            border-radius: 0.5rem; /* rounded-lg */
            transition: background-color 0.2s;
        }

        .form-button:hover {
            background-color: #0f766e; /* hover:bg-primary-dark (Darker Teal) */
        }
        
        /* Error message styling */
        .error-message {
            background-color: #fee2e2;
            border: 1px solid #fca5a5;
            color: #b91c1c;
            padding: 0.75rem;
            border-radius: 0.375rem;
            margin-bottom: 1.5rem;
            text-align: center;
            font-size: 0.875rem;
        }
        
        /* Radio Button Styling Override for Teal */
        input[type="radio"] {
            accent-color: #0d9488; /* This forces the browser to use the teal color */
            width: 1rem;
            height: 1rem;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="w-full max-w-sm login-card">
        <div class="top-right-button-container">
            <!-- Clicking Back returns to index.html -->
            <button class="top-right-button" onclick="window.location.href='Index.html'">Back</button> 
        </div>

        <h2 class="text-3xl font-bold text-center text-gray-800 mb-6">Welcome Back</h2>
        <p class="text-center text-gray-500 mb-8">Sign in to continue to your account.</p>

        <!-- JSP Logic for Error Message -->
        <% 
            String error = (String) request.getAttribute("errorMessage");
            if (error != null) { 
        %>
            <div class="error-message">
                <%= error %>
            </div>
        <% 
            } 
        %>

        <!-- Form points to UserLogin Servlet -->
        <form action="LoginServlet" method="post">
            
            <div class="mb-5 flex space-x-6 justify-center">
                <div class="flex items-center">
                    <input 
                        type="radio" 
                        id="role_technician"
                        name="role" 
                        value="technician" 
                        required 
                        class="text-teal-600 border-gray-300 focus:ring-teal-500"
                    />
                    <label for="role_technician" class="ml-2 block text-sm font-medium text-gray-700 cursor-pointer">
                        Technician
                    </label>
                </div>

                <div class="flex items-center">
                    <input 
                        type="radio" 
                        id="role_student"
                        name="role" 
                        value="student" 
                        required 
                        checked 
                        class="text-teal-600 border-gray-300 focus:ring-teal-500"
                    />
                    <label for="role_student" class="ml-2 block text-sm font-medium text-gray-700 cursor-pointer">
                        Student
                    </label>
                </div>
            </div>

            <div class="mb-5">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                <input 
                    type="email" 
                    id="email"
                    name="email" 
                    required 
                    placeholder="you@example.com"
                    class="form-input"
                />
            </div>

            <div class="mb-8">
                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                <input 
                    type="password" 
                    id="password"
                    name="password" 
                    required 
                    placeholder="••••••••"
                    class="form-input"
                />
            </div>

            <button 
                type="submit"
                class="form-button">Login
            </button>
            
            <div class="mt-6 text-center">
                <!-- Links to sign up page -->
                <a href="signUp.jsp" class="text-sm text-teal-600 hover:text-teal-800 font-medium transition duration-150">
                    Not registered yet? Sign up
                </a>
            </div>
            
        </form>
    </div>
</body>
</html>