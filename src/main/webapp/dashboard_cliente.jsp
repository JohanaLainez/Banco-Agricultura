<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Banca en Línea - Cliente</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --bg-main: #f8f9fa; --sidebar-bg: #ffffff; --primary-pastel: #f3a3a3; --text-dark: #333333; --border-color: #eaeaea; }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { background-color: var(--bg-main); display: flex; height: 100vh; overflow: hidden; color: var(--text-dark); }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; }
        .sidebar-brand { padding: 25px; border-bottom: 1px solid var(--border-color); text-align: center; }
        .sidebar-brand h2 { font-size: 20px; color: var(--text-dark); font-weight: 700; }
        .sidebar-brand span { color: var(--primary-pastel); }
        .sidebar-menu { list-style: none; padding: 20px 0; flex-grow: 1; }
        .sidebar-menu a { display: flex; align-items: center; padding: 11px 15px; margin: 4px 20px; color: var(--text-dark); text-decoration: none; border-radius: 8px; font-weight: 500; cursor: pointer; }
        .sidebar-menu li.active a, .sidebar-menu a:hover { background-color: #fff0f0; color: #e28e8e; }
        .sidebar-menu a i { margin-right: 12px; width: 25px; text-align: center; }
        .sidebar-user { padding: 20px; border-top: 1px solid var(--border-color); display: flex; align-items: center; }
        .user-avatar { width: 40px; height: 40px; background-color: #004b23; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 12px; }
        .main-content { flex-grow: 1; padding: 40px; overflow-y: auto; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 25px; margin-bottom: 25px; }
        .balance-box { background: linear-gradient(135deg, #004b23, #107238); color: white; padding: 30px; border-radius: 12px; text-align: center; margin-bottom: 20px; }
        .balance-box h3 { font-weight: normal; font-size: 16px; margin-bottom: 10px; opacity: 0.9;}
        .balance-box h1 { font-size: 40px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div>
            <div class="sidebar-brand"><h2>Banco<span>Agricultura</span></h2></div>
            <ul class="sidebar-menu">
                <li id="menu-resumen" class="active"><a onclick="switchTab('resumen')"><i class="fa-solid fa-wallet"></i> Mis Cuentas</a></li>
                <li id="menu-movimientos"><a onclick="switchTab('movimientos')"><i class="fa-solid fa-list-ul"></i> Historial</a></li>
            </ul>
        </div>
        <div class="sidebar-user">
            <div class="user-avatar"><i class="fa-solid fa-user"></i></div>
            <div>
                <h4 style="font-size:14px;">Cliente Web</h4>
                <p style="font-size:12px; color:gray;">Banca Personas</p>
            </div>
            <a href="index.html" style="margin-left:auto; color:red;"><i class="fa-solid fa-right-from-bracket"></i></a>
        </div>
    </div>

    <div class="main-content">
        <div id="view-resumen" class="tab-content active">
            <h1>Bienvenido a su Banca en Línea</h1>
            <p>Consulte sus productos financieros activos.</p><br>
            
            <div class="balance-box">
                <h3>Saldo Total Disponible</h3>
                <h1>$ 1,250.00</h1>
            </div>

            <div class="card">
                <h2>Cuentas Asignadas</h2>
                <ul style="margin-left: 20px; margin-top: 15px; line-height: 1.8;">
                    <li><strong>Cuenta Corriente:</strong> CTA-98765 - $ 850.00</li>
                    <li><strong>Cuenta de Ahorros:</strong> CTA-43210 - $ 400.00</li>
                </ul>
            </div>
        </div>

        <div id="view-movimientos" class="tab-content">
            <h1>Historial de Movimientos</h1>
            <p>Consulte sus últimos depósitos, retiros y transferencias.</p><br>
            <div class="card">
                <table style="width: 100%; text-align: left; border-collapse: collapse;">
                    <tr style="border-bottom: 1px solid #ddd;">
                        <th style="padding: 10px;">Fecha</th>
                        <th>Descripción</th>
                        <th>Monto</th>
                    </tr>
                    <tr>
                        <td colspan="3" style="padding: 20px; text-align: center; color: gray;">Módulo en construcción...</td>
                    </tr>
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