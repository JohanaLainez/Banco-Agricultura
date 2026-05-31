<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.banco.modelo.Empleado"%>
<%
    // Validar que solo el Dependiente (Dueño de tienda) entre aquí
    Empleado usuarioLogueado = (Empleado) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equals("Dependiente")) {
        // Nota: Si para las pruebas quieres entrar sin login, comenta estas dos líneas de abajo
        response.sendRedirect("index.html?error=sesion_invalida");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Portal de Dependientes - Banco Agricultura</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Mismos estilos base de tu proyecto para mantener consistencia */
        :root { --bg-main: #f8f9fa; --sidebar-bg: #ffffff; --primary-pastel: #f3a3a3; --text-dark: #333333; --border-color: #eaeaea; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: var(--bg-main); display: flex; height: 100vh; overflow: hidden; color: var(--text-dark); }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; }
        .sidebar-brand { padding: 25px; border-bottom: 1px solid var(--border-color); text-align: center; }
        .sidebar-brand h2 { font-size: 20px; color: var(--text-dark); font-weight: 700; }
        .sidebar-brand span { color: var(--primary-pastel); }
        .sidebar-user { padding: 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; }
        .user-avatar { width: 40px; height: 40px; background-color: #004b23; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 12px; }
        .main-content { flex-grow: 1; padding: 40px; overflow-y: auto; }
        .card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 25px; margin-bottom: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
        .form-group { margin-bottom: 15px; }
        label { font-weight: bold; display: block; margin-bottom: 5px; font-size: 14px;}
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; }
        button { background-color: #004b23; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; width: 100%; margin-top: 10px; }
        button:hover { background-color: #107238; }
        .result-box { margin-top: 15px; padding: 15px; background: #e9ecef; border-radius: 6px; display: none; }
        .btn-red { background-color: #d9534f; }
        .btn-red:hover { background-color: #c9302c; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <div class="sidebar-brand"><h2>Banco<span>Agricultura</span></h2></div>
            <div style="padding: 20px;">
                <p style="color: gray; font-size: 13px; text-align: center;">Módulo de Corresponsales (API REST)</p>
            </div>
        </div>
        <div class="sidebar-user">
            <div class="user-avatar">D</div>
            <div>
                <h4 style="font-size:14px;">Tienda Afiliada</h4>
                <p style="font-size:12px; color:gray;">Dependiente</p>
            </div>
            <a href="index.html" style="margin-left:auto; color:red;"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </div>

    <div class="main-content">
        <h1>Servicios de Corresponsal Bancario</h1>
        <p>Utilice la API REST para buscar cuentas, recibir abonos o procesar retiros.</p><br>

        <div class="card">
            <h2 style="margin-bottom: 15px;"><i class="fa-solid fa-magnifying-glass"></i> 1. Buscar Cuentas del Cliente</h2>
            <div class="form-group">
                <label>Número de DUI del Cliente:</label>
                <input type="text" id="duiBusqueda" placeholder="Ej: 00000000-1">
            </div>
            <button onclick="buscarCuentasAPI()"><i class="fa-solid fa-search"></i> Buscar Cuentas en API</button>
            
            <div id="cajaResultados" class="result-box">
                <h4 style="margin-bottom: 10px; color: #004b23;">Cuentas Encontradas:</h4>
                <ul id="listaCuentas" style="margin-left: 20px;"></ul>
            </div>
        </div>

        <div class="card">
            <h2 style="margin-bottom: 15px;"><i class="fa-solid fa-money-bill-transfer"></i> 2. Procesar Transacción</h2>
            <div class="form-group">
                <label>Número de Cuenta (Copielo de arriba):</label>
                <input type="text" id="numeroCuentaTx" placeholder="Ej: CTA-12345">
            </div>
            <div class="form-group">
                <label>Monto a Transar ($):</label>
                <input type="number" id="montoTx" step="0.01" placeholder="Ej: 25.00">
            </div>
            <div style="display: flex; gap: 15px; margin-top: 20px;">
                <button onclick="procesarTransaccionAPI('abonarefectivo')" style="margin-top: 0;"><i class="fa-solid fa-arrow-up"></i> Realizar Abono</button>
                <button onclick="procesarTransaccionAPI('retirarefectivo')" class="btn-red" style="margin-top: 0;"><i class="fa-solid fa-arrow-down"></i> Realizar Retiro</button>
            </div>
        </div>
    </div>

    <script>
        // Nota: Asegúrate de que "api/" sea la ruta base configurada en tu proyecto (ApplicationPath)
        const BASE_URL = "api"; 

        // 1. Consumir endpoint @GET de CuentaResource
        function buscarCuentasAPI() {
            let dui = document.getElementById("duiBusqueda").value;
            if(!dui) { alert("Ingrese un DUI válido"); return; }

            fetch(BASE_URL + "/cuentas/" + dui)
                .then(response => {
                    if(!response.ok) throw new Error("No se encontraron cuentas");
                    return response.json();
                })
                .then(data => {
                    let lista = document.getElementById("listaCuentas");
                    lista.innerHTML = "";
                    if(data.length === 0) {
                        lista.innerHTML = "<li>No hay cuentas para este DUI.</li>";
                    } else {
                        data.forEach(cuenta => {
                            lista.innerHTML += "<li><strong>" + cuenta.numero_cuenta + "</strong> - Saldo: $" + cuenta.saldo + "</li>";
                        });
                    }
                    document.getElementById("cajaResultados").style.display = "block";
                })
                .catch(error => {
                    alert("Error: " + error.message);
                    console.error(error);
                });
        }

        // 2. Consumir endpoint @POST de TransaccionResource
        function procesarTransaccionAPI(tipoOperacion) {
            let cuenta = document.getElementById("numeroCuentaTx").value;
            let monto = parseFloat(document.getElementById("montoTx").value);

            if(!cuenta || isNaN(monto) || monto <= 0) {
                alert("Verifique que la cuenta y el monto sean válidos.");
                return;
            }

            // Crear el objeto JSON esperado por Java (OperacionRequest.java)
            let payload = {
                numeroCuenta: cuenta,
                monto: monto
            };

            fetch(BASE_URL + "/transacciones/" + tipoOperacion, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            })
            .then(response => {
                if(response.ok) {
                    alert("¡Transacción procesada con éxito a través de la API!");
                    document.getElementById("montoTx").value = "";
                    document.getElementById("numeroCuentaTx").value = "";
                } else {
                    alert("La API rechazó la transacción (Revise fondos o número de cuenta).");
                }
            })
            .catch(error => {
                alert("Error de conexión con la API REST.");
                console.error(error);
            });
        }
    </script>
</body>
</html>