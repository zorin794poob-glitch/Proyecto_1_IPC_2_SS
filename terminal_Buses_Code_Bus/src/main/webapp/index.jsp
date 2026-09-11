<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Iniciar Sesión</title>
        <jsp:include page="/includes/resources_Boostrap.jsp"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/css_Login.css" >
    </head>

    <body>
          <!-- fondo y encabezado -->
        <jsp:include page="includes/background.jsp"/>
        <div class="login-card">
            <div class="login-logo">
                <!--
                    Si tienes un logo utiliza:
                    <img
                        src="${pageContext.request.contextPath}/img/logo.png"
                        alt="Logo del sistema">
                -->
                <!-- Mientras no tengas logo -->
                <i class="bi bi-person-fill"></i>
            </div>

            <h1 class="login-title"> Bienvenido </h1>
            <p class="login-subtitle"> Ingresa a tu cuenta </p>
            
            <!-- formulario -->
            <form method="POST">

                 <!-- usuario -->
                <div class="input-container">
                    <i class="bi bi-person-fill"></i>
                    <input 
                        type="text"
                        name="usuario"
                        id="usuario"    
                        placeholder="Usuario"
                        autocomplete="username"
                        required>
                </div>


                 <!-- constrasenia -->
                <div class="input-container">
                    <i class="bi bi-lock-fill"></i>
                    <input
                        type="password"
                        name="password"
                        id="password"
                        placeholder="Contraseña"
                        autocomplete="current-password"
                        required>
                </div>

                <!-- recuperar/pendiente -->
                <!-- <div class="login-options">
                     <label class="remember-me">
                         <input
                             type="checkbox"
                             name="recordar"
                             value="true">
                         Recordarme
                     </label>
                    <a
                        href="${pageContext.request.contextPath}/recuperarPassword.jsp"
                        class="forgot-password">
                        ¿Olvidaste tu contraseña?
                    </a>
                </div>
                -->
                <!-- enviar datos -->
                <button
                    type="submit"
                    class="btn-login">
                    <i class="bi bi-box-arrow-in-right"></i>
                    INGRESAR
                </button>

            </form>
            <!-- captar datos -->
            <div class="register-container">
                ¿No tienes una cuenta?
                <a
                    href="${pageContext.request.contextPath}/includes/crear_Usuarios.jsp">
                    Regístrate
                </a>
            </div>
        </div>
    </body>
</html>