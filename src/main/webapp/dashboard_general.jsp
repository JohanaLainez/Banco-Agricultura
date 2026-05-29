<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.banco.modelo.Empleado"%>
<%@page import="com.banco.dao.EmpleadoDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.banco.dao.TransaccionDAO"%>
<%
    // 1. Protección de pantalla de seguridad
    Empleado usuarioLogueado = (Empleado) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equals("Gerente General")) {
        response.sendRedirect("index.html?error=sesion_invalida");
        return;
    }

    // 2. Carga de datos reales de MySQL (Talento Humano)
    EmpleadoDAO empleadoDAO = new EmpleadoDAO();
    List<Empleado> listaPendientes = empleadoDAO.obtenerPendientes();

    // 3. Carga de movimientos financieros optimizada en arreglos de texto
    TransaccionDAO transaccionDAO = new TransaccionDAO();
    List<String[]> listaTransacciones = transaccionDAO.obtenerHistorialGlobal();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Control Avanzado - Gerente General</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-main: #f8f9fa;
            --sidebar-bg: #ffffff;
            --primary-pastel: #f3a3a3; /* El rosa pastel de la identidad de marca */
            --primary-hover: #e28e8e;
            --text-dark: #333333;
            --text-muted: #777777;
            --border-color: #eaeaea;
            --success-color: #d4edda;
            --success-text: #155724;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: var(--bg-main); display: flex; height: 100vh; overflow: hidden; color: var(--text-dark); }

        /* Estilos de la Barra Lateral Premium */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; }
        .sidebar-brand { padding: 25px; border-bottom: 1px solid var(--border-color); text-align: center; }
        .sidebar-brand h2 { font-size: 20px; color: var(--text-dark); font-weight: 700; letter-spacing: 0.5px; }
        .sidebar-brand span { color: var(--primary-pastel); }
        
        .sidebar-menu { list-style: none; padding: 20px 0; flex-grow: 1; }
        .sidebar-group-title { padding: 10px 25px; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); font-weight: 700; }
        .sidebar-menu li { padding: 2px 20px; margin-bottom: 4px; }
        .sidebar-menu a { display: flex; align-items: center; padding: 11px 15px; color: var(--text-dark); text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.3s; cursor: pointer; }
        .sidebar-menu li.active a, .sidebar-menu a:hover { background-color: #fff0f0; color: var(--primary-hover); }
        .sidebar-menu a i { margin-right: 12px; font-size: 16px; width: 25px; text-align: center; }

        .sidebar-user { padding: 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; background-color: #fffcfcfc; }
        .user-avatar { width: 40px; height: 40px; background-color: var(--primary-pastel); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 12px; }
        .sidebar-user h4 { font-size: 14px; color: var(--text-dark); }
        .sidebar-user p { font-size: 12px; color: var(--text-muted); }
        .logout-btn { color: #dc3545; text-decoration: none; margin-left: auto; font-size: 18px; transition: color 0.2s; }
        .logout-btn:hover { color: #bd2130; }

        /* Contenedor Contenido Principal */
        .main-content { flex-grow: 1; padding: 40px; overflow-y: auto; display: flex; flex-direction: column; }
        .header-title { margin-bottom: 30px; }
        .header-title h1 { font-size: 28px; font-weight: 600; margin-bottom: 5px; }
        .header-title p { color: var(--text-muted); font-size: 15px; }

        /* Vistas dinámicas */
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.4s ease; }

        /* Tarjetas Profesionales */
        .card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.01); margin-bottom: 25px; }
        .card-header { margin-bottom: 20px; border-bottom: 2px solid var(--bg-main); padding-bottom: 10px; display: flex; align-items: center; gap: 10px; }
        .card-header h2 { font-size: 18px; font-weight: 600; }

        /* Tablas Modernas */
        .table-responsive { width: 100%; overflow-x: auto; border-radius: 8px; border: 1px solid var(--border-color); }
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; }
        th { background-color: #fafafa; padding: 14px; font-weight: 600; border-bottom: 2px solid var(--border-color); color: #555; }
        td { padding: 12px 14px; border-bottom: 1px solid var(--border-color); color: #444; }
        tr:hover { background-color: #fbfbfb; }
        
        .btn-table-ver { background-color: #6c757d; color: white; border: none; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; transition: 0.2s; }
        .btn-table-ver:hover { background-color: #5a6268; }

        /* Grid de Detalles */
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .form-grid-sucursal { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        label { font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #666; }
        input { padding: 11px 15px; border: 1px solid #dddddd; border-radius: 8px; font-size: 14px; background-color: #fafafa; font-weight: 500; }
        input:focus { outline: none; border-color: var(--primary-pastel); background-color: white; }

        /* Botones de acción */
        .actions-row { margin-top: 25px; display: flex; gap: 15px; }
        .btn-action { padding: 12px 25px; border-radius: 8px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-action.accept { background-color: #4e9f3d; color: white; }
        .btn-action.accept:hover { background-color: #3e8e2d; }
        .btn-action.reject { background-color: #d9534f; color: white; }
        .btn-action.reject:hover { background-color: #c9302c; }

        .alert-success { background-color: var(--success-color); color: var(--success-text); padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #c3e6cb; font-weight: 500; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <div class="sidebar-brand">
                <h2>Banco<span>Agricultura</span></h2>
            </div>
            <ul class="sidebar-menu">
                <div class="sidebar-group-title">Gestión de Talento</div>
                <li id="menu-talento" class="active">
                    <a onclick="switchTab('talento')"><i class="fa-solid fa-user-check"></i>Aprobar Talento</a>
                </li>
                
                <div class="sidebar-group-title">Expansión y Sedes</div>
                <li id="menu-sucursales">
                    <a onclick="switchTab('sucursales')"><i class="fa-solid fa-building-shield"></i>Nueva Sucursal</a>
                </li>
                
                <div class="sidebar-group-title">Auditoría Global</div>
                <li id="menu-movimientos">
                    <a onclick="switchTab('movimientos')"><i class="fa-solid fa-receipt"></i>Movimientos Bancarios</a>
                </li>
            </ul>
        </div>

        <div class="sidebar-user">
            <div class="user-avatar">
                <%= usuarioLogueado.getNombre().substring(0,1).toUpperCase() %>
            </div>
            <div class="user-info">
                <h4><%= usuarioLogueado.getNombre() %></h4>
                <p><%= usuarioLogueado.getRol() %></p>
            </div>
            <a href="index.html" class="logout-btn" title="Cerrar Sesión">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </div>
    </div>

    <div class="main-content">
        
        <div id="view-talento" class="tab-content active">
            <div class="header-title">
                <h1>Aprobación de Talento Humano</h1>
                <p>Evalúe, autorice o deniegue el alta de las solicitudes de contratación enviadas por los Gerentes de Sede.</p>
            </div>

            <% if(request.getParameter("update") != null && request.getParameter("update").equals("success")) { %>
                <div class="alert-success"><i class="fa-solid fa-circle-check"></i> ¡Estado de talento actualizado correctamente en la base de datos!</div>
            <% } %>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-clock" style="color: var(--primary-pastel);"></i> Solicitudes Pendientes</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Cargo Solicitado</th>
                                <th>Nombre Candidato</th>
                                <th>Sucursal Sede</th>
                                <th>DUI Documento</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if(listaPendientes != null && !listaPendientes.isEmpty()) {
                                    for(Empleado emp : listaPendientes) {
                            %>
                                <tr>
                                    <td><strong><%= emp.getRol() %></strong></td>
                                    <td><%= emp.getNombre() %></td>
                                    <td><i class="fa-solid fa-location-dot" style="color: #bbb;"></i> <%= emp.getSucursal() %></td>
                                    <td><%= emp.getDui() %></td>
                                    <td>
                                        <button class="btn-table-ver" onclick="cargarDetalle(<%= emp.getIdEmpleado() %>, '<%= emp.getDui() %>', '<%= emp.getNombre() %>', '<%= emp.getSucursal() %>', '<%= emp.getRol() %>', '<%= emp.getDireccion() %>', '<%= emp.getTelefono() %>')">
                                            <i class="fa-solid fa-eye"></i> Ver Ficha
                                        </button>
                                    </td>
                                </tr>
                            <%  
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="5" style="text-align: center; font-style: italic; color: var(--text-muted); padding: 20px;">No hay solicitudes de contratación pendientes por el momento.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-id-card" style="color: var(--primary-pastel);"></i> Ficha de Evaluación Laboral</h2>
                </div>
                <form id="formAccion" action="EmpleadoServlet" method="POST">
                    <input type="hidden" id="idEmpleadoTxt" name="id" value="">
                    <input type="hidden" id="accionTxt" name="accion" value="">

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Documento Único de Identidad (DUI)</label>
                            <input type="text" id="viewDui" readonly placeholder="Seleccione un registro...">
                        </div>
                        <div class="form-group">
                            <label>Nombre Completo del Postulante</label>
                            <input type="text" id="viewNombre" readonly placeholder="Seleccione un registro...">
                        </div>
                        <div class="form-group">
                            <label>Sucursal Destino</label>
                            <input type="text" id="viewSucursal" readonly placeholder="Seleccione un registro...">
                        </div>
                        <div class="form-group">
                            <label>Cargo Propuesto</label>
                            <input type="text" id="viewCargo" readonly placeholder="Seleccione un registro...">
                        </div>
                        <div class="form-group">
                            <label>Dirección Domiciliaria</label>
                            <input type="text" id="viewDireccion" readonly placeholder="Seleccione un registro...">
                        </div>
                        <div class="form-group">
                            <label>Número de Teléfono</label>
                            <input type="text" id="viewTelefono" readonly placeholder="Seleccione un registro...">
                        </div>
                    </div>

                    <div class="actions-row">
                        <button type="button" class="btn-action accept" onclick="procesar('aceptar')">
                            <i class="fa-solid fa-user-check"></i> Autorizar Contratación
                        </button>
                        <button type="button" class="btn-action reject" onclick="procesar('rechazar')">
                            <i class="fa-solid fa-user-xmark"></i> Rechazar Acción
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div id="view-sucursales" class="tab-content">
            <div class="header-title">
                <h1>Expansión Bancaria e Infraestructura</h1>
                <p>Apertura y registro global de nuevos puntos de servicio financieros autorizados en el territorio nacional.</p>
            </div>

            <% if(request.getParameter("status_sucursal") != null && request.getParameter("status_sucursal").equals("success")) { %>
                <div class="alert-success"><i class="fa-solid fa-circle-check"></i> ¡Nueva sucursal aperturada e incorporada exitosamente al sistema global!</div>
            <% } %>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-building-circle-check" style="color: var(--primary-pastel);"></i> Formulario de Apertura Institucional</h2>
                </div>
                
                <form action="${pageContext.request.contextPath}/SucursalServlet" method="POST">
                    <div class="form-grid-sucursal">
                        <div class="form-group">
                            <label>Nombre de la Sucursal</label>
                            <input type="text" name="txtNombreSucursal" required placeholder="Ej: San Salvador Oeste">
                        </div>
                        <div class="form-group">
                            <label>Código de Sucursal</label>
                            <input type="text" name="txtCodigoSucursal" required placeholder="Ej: SS-OESTE-04">
                        </div>
                        <div class="form-group">
                            <label>Dirección Física de la Sede</label>
                            <input type="text" name="txtDireccion" required placeholder="Ej: Km 12, Carretera a Santa Tecla">
                        </div>
                        <div class="form-group">
                            <label>Nombre del Gerente Asignado</label>
                            <input type="text" name="txtNombreGerente" required placeholder="Ej: Carlos Alfredo Ramos">
                        </div>
                        <div class="form-group">
                            <label>Presupuesto Inicial asignado ($)</label>
                            <input type="number" step="0.01" name="txtPresupuesto" required placeholder="Ej: 75000.00">
                        </div>
                        <div class="form-group">
                            <label>Cajas Físicas Disponibles</label>
                            <input type="number" name="txtCajas" required placeholder="Ej: 4">
                        </div>
                    </div>

                    <div class="actions-row" style="margin-top: 30px;">
                        <button type="submit" class="btn-action accept" style="background-color: #837171;">
                            <i class="fa-solid fa-square-plus"></i> Registrar y Aperturar Sucursal
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div id="view-movimientos" class="tab-content">
            <div class="header-title">
                <h1>Auditoría de Movimientos Bancarios</h1>
                <p>Libro de control global de transacciones, depósitos, retiros y estados de cuentas en tiempo real.</p>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-list-check" style="color: var(--primary-pastel);"></i> Registro de Operaciones Globales</h2>
                </div>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID Operación</th>
                                <th>Número de Cuenta</th>
                                <th>Tipo de Movimiento</th>
                                <th>Monto Transado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if(listaTransacciones != null && !listaTransacciones.isEmpty()) {
                                    for(String[] t : listaTransacciones) {
                                        String idTransaccion = t[0];
                                        String numeroCuenta = t[1];
                                        String tipoMovimiento = t[2];
                                        double monto = Double.parseDouble(t[3]);
                                        
                                        // Distintivo financiero dinámico
                                        String badgeColor = tipoMovimiento.equalsIgnoreCase("Deposito") ? "#4e9f3d" : "#d9534f";
                            %>
                                <tr>
                                    <td>#<%= idTransaccion %></td>
                                    <td><strong><%= numeroCuenta %></strong></td>
                                    <td>
                                        <span style="color: white; background-color: <%= badgeColor %>; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600; display: inline-block; text-transform: uppercase;">
                                            <%= tipoMovimiento %>
                                        </span>
                                    </td>
                                    <td style="font-weight: 700; color: #222;">$<%= String.format("%.2f", monto) %></td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="4" style="text-align: center; font-style: italic; color: var(--text-muted); padding: 30px; font-size: 14px;">No se registran movimientos bancarios en el core institucional aún.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
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

        function cargarDetalle(id, dui, nombre, sucursal, cargo, direccion, telefono) {
            document.getElementById('idEmpleadoTxt').value = id;
            document.getElementById('viewDui').value = dui;
            document.getElementById('viewNombre').value = nombre;
            document.getElementById('viewSucursal').value = sucursal;
            document.getElementById('viewCargo').value = cargo;
            document.getElementById('viewDireccion').value = direccion;
            document.getElementById('viewTelefono').value = telefono;
        }

        function procesar(tipoAccion) {
            var id = document.getElementById('idEmpleadoTxt').value;
            if(!id) {
                alert('Por favor, seleccione primero un registro válido usando el botón "Ver Ficha".');
                return;
            }
            document.getElementById('accionTxt').value = tipoAccion;
            document.getElementById('formAccion').submit();
        }

        window.onload = function() {
            var urlParams = new URLSearchParams(window.location.search);
            if(urlParams.has('tab')) {
                switchTab(urlParams.get('tab'));
            }
        }
    </script>
</body>
</html>