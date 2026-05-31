package com.banco.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL = "jdbc:mysql://localhost:3306/banco_agricultura";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static Connection getConexion() {
        Connection conexion = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("¡CONEXIÓN EXITOSA DESDE JAVA A MYSQL!");
        } catch (ClassNotFoundException e) {
            System.out.println("CRÍTICO: No se encontró el driver JDBC de MySQL.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("CRÍTICO: Error de credenciales o el servidor MySQL está apagado.");
            System.out.println("Mensaje de MySQL: " + e.getMessage());
            e.printStackTrace();
        }

        return conexion;
    }
}