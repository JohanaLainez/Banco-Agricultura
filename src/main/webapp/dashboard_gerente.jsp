<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.banco.modelo.Empleado"%>
<%@page import="java.util.List"%>
<%
    // Protección de seguridad para Gerente de Sucursal
    Empleado usuarioLogueado = (Empleado) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equals("Gerente de Sucursal")) {
        response.sendRedirect("index.html?error=sesion_invalida");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Gerente de Sucursal - Banco Agricultura</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-main: #f8f9fa;
            --sidebar-bg: #ffffff;
            --primary-pastel: #f3a3a3; 
            --primary-hover: #e28e8e;
            --text-dark: #333333;
            --text-muted: #777777;
            --border-color: #eaeaea;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: var(--bg-main); display: flex; height: 100vh; overflow: hidden; color: var(--text-dark); }
        
        /* Sidebar Idéntico al General */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; }
        .sidebar-brand { padding: 25px; border-bottom: 1px solid var(--border-color); text-align: center; }
        .sidebar-brand h2 { font-size: 20px; color: var(--text-dark); font-weight: 700; }
        .sidebar-brand span { color: var(--primary-pastel); }
        .sidebar-menu { list-style: none; padding: 20px 0; flex-grow: 1; }
        .sidebar-menu a { display: flex; align-items: center; padding: 11px 15px; margin: 4px 20px; color: var(--text-dark); text-decoration: none; border-radius: 8px; font-weight: 500; cursor: pointer; }
        .sidebar-menu li.active a, .sidebar-menu a:hover { background-color: #fff0f0; color: var(--primary-hover); }
        .sidebar-menu a i { margin-right: 12px; width: 25px; text-align: center; }
        
        .sidebar-user { padding: 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; }
        .user-avatar { width: 40px; height: 40px; background-color: var(--primary-pastel); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 12px; }
        
        /* Contenido */
        .main-content { flex-grow: 1; padding: 40px; overflow-y: auto; }
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.4s ease; }
        .card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 25px; margin-bottom: 25px; }
        .card-header h2 { font-size: 18px; margin-bottom: 15px; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background-color: #fafafa; padding: 14px; border-bottom: 2px solid var(--border-color); text-align: left;}
        td { padding: 12px 14px; border-bottom: 1px solid var(--border-color); }
        
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .form-group { display: flex; flex-direction: column; }
        input, select { padding: 10px; border: 1px solid #ddd; border-radius: 6px; }
        button { padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; color: white; }
        .btn-green { background-color: #4e9f3d; }
        .btn-red { background-color: #d9534f; }
        
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <div class="sidebar-brand"><h2>Banco<span>Agricultura</span></h2></div>
            <ul class="sidebar-menu">
                <li id="menu-empleados" class="active"><a onclick="switchTab('empleados')"><i class="fa-solid fa-users"></i> Mis Empleados</a></li>
                <li id="menu-prestamos"><a onclick="switchTab('prestamos')"><i class="fa-solid fa-hand-holding-dollar"></i> Préstamos</a></li>
            </ul>
        </div>
        <div class="sidebar-user">
            <div class="user-avatar"><%= usuarioLogueado.getNombre().substring(0,1).toUpperCase() %></div>
            <div>
                <h4 style="font-size:14px;"><%= usuarioLogueado.getNombre() %></h4>
                <p style="font-size:12px; color:gray;"><%= usuarioLogueado.getRol() %></p>
            </div>
            <a href="index.html" style="margin-left:auto; color:red;"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </div>

    <div class="main-content">
        <div id="view-empleados" class="tab-content active">
            <h1>Gestión de Empleados de Sucursal</h1>
            <p>Contrate nuevo personal o gestione las bajas.</p><br>
            
            <div class="card">
                <div class="card-header"><h2>Contratar Nuevo Empleado</h2></div>
                <form action="EmpleadoServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <input type="hidden" name="sucursal" value="<%= usuarioLogueado.getSucursal() %>">
                    
                    <div class="form-grid">
                        <div class="form-group"><label>DUI</label><input type="text" name="dui" required></div>
                        <div class="form-group"><label>Nombre Completo</label><input type="text" name="nombre" required></div>
                        <div class="form-group">
                            <label>Rol</label>
                            <select name="rol">
                                <option>Cajero</option>
                                <option>Personal de Limpieza</option>
                                <option>Secretaria</option>
                                <option>Asesor Financiero</option>
                            </select>
                        </div>
                        <div class="form-group"><label>Teléfono</label><input type="text" name="telefono" required></div>
                        <div class="form-group"><label>Dirección</label><input type="text" name="direccion" required></div>
                        <div class="form-group"><label>Usuario Sistema</label><input type="text" name="usuario" required></div>
                        <div class="form-group"><label>Clave Temporal</label><input type="password" name="clave" required></div>
                    </div><br>
                    <button type="submit" class="btn-green">Enviar a Aprobación (Gerencia General)</button>
                </form>
            </div>

            </div>

        <div id="view-prestamos" class="tab-content">
            <h1>Aprobación de Préstamos</h1>
            <p>Revise las solicitudes enviadas por los cajeros.</p><br>
            
            <div class="card">
                <div class="card-header"><h2>Casos en Espera</h2></div>
                <table>
                    <thead><tr><th>ID Préstamo</th><th>DUI Cliente</th><th>Monto</th><th>Plazo</th><th>Acción</th></tr></thead>
                    <tbody>
                        <tr><td colspan="5" style="text-align:center;">Cargando préstamos... (Requiere Servlet)</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.sidebar-menu li').forEach(el => el.classList.remove('active'));
            document.getElementById('view-' + tabName).classList.add('active');
            document.getElementById('menu-' + tabName).classList.add('active');
        }
    </script>
</body>
</html>