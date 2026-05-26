package com.banco.dao;

import com.banco.conexion.Conexion;
import com.banco.modelo.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ClienteDAO {

    public Cliente buscarPorDui(String dui) {
        Cliente cliente = null;

        String sql = "SELECT * FROM clientes WHERE dui = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dui);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setIdCliente(rs.getInt("id_cliente"));
                    cliente.setNombre(rs.getString("nombre"));
                    cliente.setDui(rs.getString("dui"));
                    cliente.setSalario(rs.getDouble("salario"));
                    cliente.setEstado(rs.getString("estado"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cliente;
    }
}