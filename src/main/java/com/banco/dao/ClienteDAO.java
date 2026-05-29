package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class ClienteDAO {

    // Este método ahora registra al cliente Y le crea su cuenta de un solo tiro
    public String registrarClienteConCuenta(Cliente c) {
        String queryCliente = "INSERT INTO clientes (dui, nombre, salario, estado) VALUES (?, ?, ?, ?)";
        
        // CORREGIDO: Incluimos 'tipo_cuenta' porque en tu MySQL es un campo obligatorio (NOT NULL)
        String queryCuenta = "INSERT INTO cuentas (numero_cuenta, tipo_cuenta, saldo, id_cliente) VALUES (?, 'Ahorros', 0.0, ?)";
        
        Connection con = null;
        String numeroCuentaGenerado = null;

        try {
            con = Conexion.getConexion();
            con.setAutoCommit(false); // Iniciamos transacción segura

            // 1. INSERTAR EL CLIENTE
            try (PreparedStatement psC = con.prepareStatement(queryCliente, Statement.RETURN_GENERATED_KEYS)) {
                psC.setString(1, c.getDui());
                psC.setString(2, c.getNombre());
                psC.setDouble(3, c.getSalario());
                psC.setString(4, c.getEstado());
                psC.executeUpdate();

                // Recuperar el ID auto-incrementado del cliente que generó MySQL
                int idCliente = 0;
                try (ResultSet rs = psC.getGeneratedKeys()) {
                    if (rs.next()) {
                        idCliente = rs.getInt(1);
                    }
                }

                // 2. GENERAR NÚMERO DE CUENTA ALEATORIO (Ej: 0012-4823-19)
                int correlativo1 = (int)(Math.random() * 9000 + 1000); // 4 dígitos
                int correlativo2 = (int)(Math.random() * 90 + 10);     // 2 dígitos
                numeroCuentaGenerado = "0012-" + correlativo1 + "-" + correlativo2;

                // 3. CREAR LA CUENTA ASOCIADA (Inyectando 'Ahorros' en tipo_cuenta)
                try (PreparedStatement psQ = con.prepareStatement(queryCuenta)) {
                    psQ.setString(1, numeroCuentaGenerado);
                    psQ.setInt(2, idCliente); // Pasamos el ID numérico correspondiente
                    psQ.executeUpdate();
                }
            }

            con.commit(); // Si todo marchó bien, guardamos de forma atómica en MySQL
            return numeroCuentaGenerado; // Retornamos la cuenta para mostrársela al cajero

        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            System.out.println("Error al registrar cliente y cuenta: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            if (con != null) {
                try { con.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }
}