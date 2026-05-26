package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Cuenta;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CuentaDAO {

    public List<Cuenta> obtenerCuentasPorDui(String dui) {
        List<Cuenta> cuentas = new ArrayList<>();

        String sql = "SELECT cu.* FROM cuentas cu "
                   + "INNER JOIN clientes cl ON cu.id_cliente = cl.id_cliente "
                   + "WHERE cl.dui = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dui);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cuenta cuenta = new Cuenta();
                    cuenta.setIdCuenta(rs.getInt("id_cuenta"));
                    cuenta.setNumeroCuenta(rs.getString("numero_cuenta"));
                    cuenta.setTipoCuenta(rs.getString("tipo_cuenta"));
                    cuenta.setSaldo(rs.getDouble("saldo"));
                    cuenta.setIdCliente(rs.getInt("id_cliente"));

                    cuentas.add(cuenta);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cuentas;
    }
}