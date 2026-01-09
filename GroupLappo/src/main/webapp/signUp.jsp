<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Lappo</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'primary': '#0d9488',      /* Teal */
                        'primary-dark': '#0f766e', /* Darker Teal */
                    }
                }
            }
        }
    </script>

    <style>
        /* Embedding styles consistent with login.jsp */
        body {
            background-color: #f3f4f6; /* Light gray background */
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0; /* Add padding for vertical scrolling space */
        }

        .login-card {
            background-color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            position: relative;
            border-top: 4px solid #0d9488; /* Teal accent border */
            margin: 20px auto; /* Center with margin */
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
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            margin-top: 0.25rem;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(13, 148, 136, 0.1);
        }

        .form-button {
            width: 100%;
            background-color: #0d9488;
            color: white;
            font-weight: 600;
            padding: 0.75rem;
            border-radius: 0.5rem;
            transition: background-color 0.2s;
            margin-top: 1rem;
        }

        .form-button:hover {
            background-color: #0f766e;
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
        
        .form-group {
            margin-bottom: 1.25rem; /* Consistent spacing */
        }
    </style>
</head>
<body>
    <div class="w-full max-w-md login-card"> <!-- Changed max-w-sm to max-w-md for more width -->
    
        <div class="top-right-button-container">
            <!-- Clicking Back returns to login.jsp -->
            <button class="top-right-button" type="button" onclick="window.location.href='Index.html'">Back</button> 
        </div>

        <h2 class="text-3xl font-bold text-center text-gray-800 mb-6">Create Account</h2>
        <p class="text-center text-gray-500 mb-8">Register to access the repair system.</p>

        <!-- JSP Scriptlet for Server-Side Error Messages -->
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

        <form action="<%= request.getContextPath() %>/SignUpServlet" method="post">
 
   
            
            <!-- Email Input Group -->
            <div class="form-group">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                <input 
                    type="email" 
                    id="email"
                    name="email" 
                    required 
                    placeholder="you@gmail.my"
                    class="form-input"
                />
            </div>

            <!-- Name Input Group -->
            <div class="form-group">
                <label for="name" class="block text-sm font-medium text-gray-700 mb-2">User Name</label>
                <input 
                    type="text" 
                    id="name"
                    name="name" 
                    required 
                    placeholder="Enter your full name"
                    class="form-input"
                />
            </div>

            <!-- Phone Number Input Group -->
            <div class="form-group">
                <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                <input 
                    type="tel" 
                    id="phone"
                    name="phone" 
                    required 
                    placeholder="e.g. 012-3456789"
                    class="form-input"
                />
            </div>

            <!-- Address Input Group -->
            <div class="form-group">
                <label for="address" class="block text-sm font-medium text-gray-700 mb-2">Address</label>
                <input 
                    type="text" 
                    id="address"
                    name="address" 
                    required 
                    placeholder="College/Home Address"
                    class="form-input"
                />
            </div>
            
            <!-- Password Input Group -->
            <div class="form-group mb-8">
                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                <input 
                    type="password" 
                    id="password"
                    name="password" 
                    required 
                    placeholder="Create a strong password"
                    class="form-input"
                />
            </div>

            <!-- Submit Button -->
            <button type="submit" class="form-button">
                Sign Up
            </button>

            <!-- Login Link -->
            <div class="mt-6 text-center">
                <a href="LoginPage.jsp" class="text-sm text-teal-600 hover:text-teal-800 font-medium transition duration-150">
                    Already have an account? Login
                </a>
            </div>
            
        </form>
    </div>
   

</body>
</html>