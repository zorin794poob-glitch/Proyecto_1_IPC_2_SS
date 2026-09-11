<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport"content="width=device-width, initial-scale=1.0">
        <title>Crear Cuenta</title>
        <jsp:include page="/includes/resources_Boostrap.jsp"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/css_Registro.css">
    </head>


    <body>

        <jsp:include page="/includes/background.jsp"/>
        <!-- tarjeta registro-->

        <div class="register-card">

            <div class="register-icon">
                <i class="bi bi-person-plus-fill"></i>
            </div>
            <h1 class="register-title"> Crear cuenta </h1>
            <p class="register-subtitle"> Completa tus datos para registrarte</p>

            <!-- Formulario-->

            <form
                action="${pageContext.request.contextPath}/RegistroServlet"
                method="POST">


                <!-- nombre Usuario -->

                <div class="input-container">
                    <i class="bi bi-person-fill"></i>
                    <input
                        type="text"
                        name="nombre"
                        id="nombre"
                        placeholder="Nombre completo"
                        autocomplete="name"
                        required>
                </div>


                <!-- usuario (Completar rol en Servlet) (E identifiacion)-->

                <div class="input-container">
                    <i class="bi bi-person-badge-fill"></i>
                    <input
                        type="text"
                        name="usuario"
                        id="usuario"
                        placeholder="Nombre de usuario"
                        autocomplete="username"
                        required>
                </div>

                <!-- correo -->

                <div class="input-container">
                    <i class="bi bi-envelope-fill"></i>
                    <input
                        type="email"
                        name="correo"
                        id="correo"
                        placeholder="Correo electrónico"
                        autocomplete="email"
                        required>
                </div>


                <!-- contrasenia -->

                <div class="input-container">
                    <i class="bi bi-lock-fill"></i>
                    <input
                        type="password"
                        name="password"
                        id="password"
                        placeholder="Contraseña"
                        autocomplete="new-password"
                        required>
                </div>

                <!-- rectificar contrasenia -->

                <div class="input-container">
                    <i class="bi bi-shield-lock-fill"></i>
                    <input
                        type="password"
                        name="confirmarPassword"
                        id="confirmarPassword"
                        placeholder="Confirmar contraseña"
                        autocomplete="new-password"
                        required>
                </div>
                
                <!-- ingresar despues de crear -->

                <button
                    type="submit"
                    class="btn-register">
                    <i class="bi bi-person-plus-fill"></i>
                    CREAR CUENTA
                </button>

            </form>
                <--<!-- regresar a login normal -->
            <div class="login-link">
                ¿Ya tienes una cuenta?
                <a href="${pageContext.request.contextPath}/login.jsp"> Inicia sesión </a>
            </div>
        </div>
    </body>
</html>