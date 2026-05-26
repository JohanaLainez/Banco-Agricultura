package com.banco.modelo;

public class Cliente {
    private int idCliente;
    private String nombre;
    private String dui;
    private double salario;
    private String estado;

    public Cliente() {
    }

    public Cliente(int idCliente, String nombre, String dui, double salario, String estado) {
        this.idCliente = idCliente;
        this.nombre = nombre;
        this.dui = dui;
        this.salario = salario;
        this.estado = estado;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDui() {
        return dui;
    }

    public void setDui(String dui) {
        this.dui = dui;
    }

    public double getSalario() {
        return salario;
    }

    public void setSalario(double salario) {
        this.salario = salario;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}