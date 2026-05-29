<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.banco.modelo.Empleado"%>
<%
    // 1. Protección de pantalla de seguridad
    Empleado usuarioLogueado = (Empleado) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Cajero")) {
        response.sendRedirect("index.html?error=sesion_invalida");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Ventanilla - Cajero Institucional</title>
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
            --error-color: #f8d7da;
            --error-text: #721c24;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: var(--bg-main); display: flex; height: 100vh; overflow: hidden; color: var(--text-dark); }

        /* Barra Lateral Premium */
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
        .user-info h4 { font-size: 14px; color: var(--text-dark); }
        .user-info p { font-size: 12px; color: var(--text-muted); }
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

        /* Grids de Formularios */
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        label { font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #666; }
        input, select { padding: 11px 15px; border: 1px solid #dddddd; border-radius: 8px; font-size: 14px; background-color: #fafafa; font-weight: 500; }
        input:focus, select:focus { outline: none; border-color: var(--primary-pastel); background-color: white; }

        /* Botones de acción */
        .actions-row { margin-top: 25px; display: flex; gap: 15px; }
        .btn-action { padding: 12px 25px; border-radius: 8px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: 0.2s; background-color: #837171; color: white; }
        .btn-action:hover { background-color: #6e5e5e; }

        /* Alertas */
        .alert-success { background-color: var(--success-color); color: var(--success-text); padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #c3e6cb; font-weight: 500; }
        .alert-error { background-color: var(--error-color); color: var(--error-text); padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #f5c6cb; font-weight: 500; }

        /* Guías informativas de reglas de negocio */
        .reglas-box { background-color: #fffbfa; border-left: 4px solid var(--primary-pastel); padding: 15px; border-radius: 4px; margin-bottom: 20px; font-size: 13px; color: #555; }
        .reglas-box ul { margin-left: 20px; margin-top: 5px; }

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
                <div class="sidebar-group-title">Atención Presencial</div>
                <li id="menu-clientes" class="active">
                    <a onclick="switchTab('clientes')"><i class="fa-solid fa-user-plus"></i>Nuevo Cliente</a>
                </li>
                <li id="menu-dependientes">
                    <a onclick="switchTab('dependientes')"><i class="fa-solid fa-users-gear"></i>Dependientes</a>
                </li>
                
                <div class="sidebar-group-title">Operaciones Caja</div>
                <li id="menu-caja">
                    <a onclick="switchTab('caja')"><i class="fa-solid fa-vault"></i>Ventanilla Efectivo</a>
                </li>
                
                <div class="sidebar-group-title">Área de Créditos</div>
                <li id="menu-prestamos">
                    <a onclick="switchTab('prestamos')"><i class="fa-solid fa-hand-holding-dollar"></i>Apertura Préstamo</a>
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
        
        <div id="view-clientes" class="tab-content active">
            <div class="header-title">
                <h1>Registro de Clientes / Prestamistas</h1>
                <p>Función específica para usuarios que no poseen acceso a internet o requieren asesoría institucional presencial.</p>
            </div>

            <% if(request.getParameter("status_cliente") != null) { 
                String stCli = request.getParameter("status_cliente");
                if(stCli.equals("success")) { 
                    String cuenta = request.getParameter("cuenta_asignada"); %>
                    <div class="alert-success">
                        <i class="fa-solid fa-circle-check"></i> 
                        ¡Cliente registrado exitosamente! Se aperturó su Cuenta de Ahorros: 
                        <strong style="font-size: 18px; background: #fff; padding: 2px 8px; border-radius: 4px; color: #155724; margin-left: 5px;"><%= cuenta %></strong>
                    </div>
                <% } else { %>
                    <div class="alert-error"><i class="fa-solid fa-circle-xmark"></i> Error institucional: El DUI ingresado ya se encuentra registrado en el sistema.</div>
            <% } } %>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-id-card" style="color: var(--primary-pastel);"></i> Formulario de Alta de Cliente</h2>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group"><label>Documento Único de Identidad (DUI)</label><input type="text" name="txtDui" required placeholder="Ej: 00000000-0"></div>
                        <div class="form-group"><label>Nombre Completo</label><input type="text" name="txtNombre" required placeholder="Ej: Juan Pérez"></div>
                        <div class="form-group"><label>Dirección de Residencia</label><input type="text" name="txtDireccion" required placeholder="Ej: San Salvador, El Salvador"></div>
                        <div class="form-group"><label>Número de Teléfono</label><input type="text" name="txtTelefono" required placeholder="Ej: 7000-0000"></div>
                        <div class="form-group"><label>Salario Mensual Comprobable ($)</label><input type="number" step="0.01" name="txtSalario" required placeholder="Ej: 450.00"></div>
                    </div>
                    <div class="actions-row"><button type="submit" class="btn-action"><i class="fa-solid fa-floppy-disk"></i> Guardar Registro</button></div>
                </form>
            </div>
        </div>

        <div id="view-dependientes" class="tab-content">
            <div class="header-title">
                <h1>Asociación de Dependientes</h1>
                <p>Registro y vinculación de dependientes adicionales asociados a la cuenta principal.</p>
            </div>

            <% if(request.getParameter("status_dependiente") != null) { 
                String stDep = request.getParameter("status_dependiente");
                if(stDep.equals("success")) { %>
                    <div class="alert-success"><i class="fa-solid fa-circle-check"></i> ¡Dependiente vinculado exitosamente al cliente titular!</div>
                <% } else { %>
                    <div class="alert-error"><i class="fa-solid fa-circle-xmark"></i> Error institucional: No se pudo vincular el dependiente. Asegúrese de que el DUI del titular exista previamente en el sistema.</div>
            <% } } %>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-users" style="color: var(--primary-pastel);"></i> Formulario de Dependientes</h2>
                </div>
                <form action="DependienteServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group"><label>DUI del Titular</label><input type="text" name="txtDuiTitular" required placeholder="Ej: 00000000-0"></div>
                        <div class="form-group"><label>Nombre del Dependiente</label><input type="text" name="txtNombreDependiente" required placeholder="Ej: María Pérez"></div>
                        <div class="form-group"><label>Parentesco</label><input type="text" name="txtParentesco" required placeholder="Ej: Hijo/a, Cónyuge"></div>
                    </div>
                    <div class="actions-row"><button type="submit" class="btn-action"><i class="fa-solid fa-user-plus"></i> Vincular Dependiente</button></div>
                </form>
            </div>
        </div>

        <div id="view-caja" class="tab-content">
            <div class="header-title">
                <h1>Operaciones de Caja en Ventanilla</h1>
                <p>Gestión directa de ingresos y egresos de efectivo con validación obligatoria de seguridad.</p>
            </div>

            <% if(request.getParameter("status") != null) { 
                String status = request.getParameter("status");
                if(status.equals("success")) { %>
                    <div class="alert-success"><i class="fa-solid fa-circle-check"></i> ¡Transacción procesada con éxito! El saldo de la cuenta ha sido actualizado.</div>
                <% } else if(status.equals("error_validacion")) { %>
                    <div class="alert-error"><i class="fa-solid fa-circle-xmark"></i> <strong>Error de Validación:</strong> <%= request.getParameter("msg") %></div>
                <% } else if(status.equals("error_fondos")) { %>
                    <div class="alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <strong>Error de Fondos:</strong> <%= request.getParameter("msg") %></div>
            <% } } %>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-money-bill-transfer" style="color: var(--primary-pastel);"></i> Depósitos y Retiros institucionales</h2>
                </div>

                
                <form action="${pageContext.request.contextPath}/TransaccionServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Documento Único de Identidad (DUI)</label>
                            <input type="text" name="txtDui" required placeholder="Ej: 00000000-0">
                        </div>
                        <div class="form-group">
                            <label>Número de Cuenta Bancaria</label>
                            <input type="text" name="txtNumeroCuenta" required placeholder="Ej: 0012-3456-78">
                        </div>
                        <div class="form-group">
                            <label>Tipo de Operación</label>
                            <select name="cmbTipoTransaccion" required>
                                <option value="Deposito">Depósito de Efectivo (+)</option>
                                <option value="Retiro">Retiro en Ventanilla (-)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Monto de la Operación ($)</label>
                            <input type="number" step="0.01" name="txtMonto" min="0.01" required placeholder="Ej: 150.00">
                        </div>
                    </div>
                    <div class="actions-row">
                        <button type="submit" class="btn-action" style="background-color: #4e9f3d;">
                            <i class="fa-solid fa-cash-register"></i> Procesar Operación
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div id="view-prestamos" class="tab-content">
            <div class="header-title">
                <h1>Apertura de Préstamos Financieros</h1>
                <p>Evaluación inteligente de líneas de crédito basada en políticas de salarios institucionales.</p>
            </div>
            <% if(request.getParameter("status_prestamo") != null) { 
                String stPre = request.getParameter("status_prestamo");
                if(stPre.equals("success")) { %>
                    <div class="alert-success"><i class="fa-solid fa-circle-check"></i> ¡Solicitud ingresada con éxito! El caso pasó a estudio en estado 'En Espera'.</div>
                <% } else if(stPre.equals("error_monto")) { %>
                    <div class="alert-error"><i class="fa-solid fa-circle-xmark"></i> <strong>Rechazo de Política:</strong> El monto solicitado supera el límite máximo de $<%= request.getParameter("max") %> autorizado para ese salario.</div>
                <% } else if(stPre.equals("error_capacidad")) { %>
                    <div class="alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <strong>Capacidad Insuficiente:</strong> La cuota mensual estimada ($<%= request.getParameter("cuota") %>) supera el 30% del salario del solicitante.</div>
                <% } else { %>
                    <div class="alert-error"><i class="fa-solid fa-circle-xmark"></i> Error institucional: No se pudo procesar la solicitud. Asegúrese de que el cliente exista.</div>
            <% } } %>
            <div class="card">
                <div class="card-header">
                    <h2><i class="fa-solid fa-calculator" style="color: var(--primary-pastel);"></i> Formulario de Simulación y Solicitud</h2>
                </div>
                <div class="reglas-box">
                    <strong>Políticas Institucionales de Crédito:</strong>
                    <ul>
                        <li>Salarios menores a $365: Préstamo máximo de $10,000 con interés del 3%</li>
                        <li>Salarios menores a $600: Préstamo máximo de $25,000 con interest del 3%</li>
                        <li>Salarios menores a $900: Préstamo máximo de $35,000 con interés del 4%</li>
                        <li>Salarios mayores a $1,000: Préstamo máximo de $50,000 con interés del 5%</li>
                        <li><strong>Restricción:</strong> La cuota mensual estimada no debe superar el 30% del salario del solicitante.</li>
                    </ul>
                </div>
                <form action="PrestamoServlet" method="POST">
                    <div class="form-grid">
                        <div class="form-group"><label>DUI del Solicitante</label><input type="text" name="txtDui" required placeholder="Ej: 00000000-0"></div>
                        <div class="form-group"><label>Salario Comprobado ($)</label><input type="number" step="0.01" name="txtSalario" required placeholder="Ej: 500.00"></div>
                        <div class="form-group"><label>Monto Solicitado ($)</label><input type="number" step="0.01" name="txtMonto" required placeholder="Ej: 15000.00"></div>
                        <div class="form-group">
                            <label>Plazo Financiero</label>
                            <select name="txtPlazo" required>
                                <option value="1">1 Año (12 Meses)</option>
                                <option value="2">2 Años (24 Meses)</option>
                                <option value="3">3 Años (36 Meses)</option>
                                <option value="4">4 Años (48 Meses)</option>
                                <option value="5">5 Años (60 Meses)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Estado Inicial de Apertura</label>
                            <input type="text" name="txtEstado" value="en espera" readonly style="font-weight: bold; color: #b7791f; background-color: #fefcbf;">
                        </div>
                    </div>
                    <div class="actions-row"><button type="submit" class="btn-action"><i class="fa-solid fa-folder-plus"></i> Aperturar Caso de Crédito</button></div>
                </form>
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

        window.onload = function() {
            var urlParams = new URLSearchParams(window.location.search);
            if(urlParams.has('tab')) {
                switchTab(urlParams.get('tab'));
            }
        }
    </script>
</body>
</html>