package com.banco.modelo;

public class Prestamo {
    // 1. Atributos encapsulados alineados con la base de datos
    private int idPrestamo;
    private String duiCliente;
    private double montoSolicitado;
    private double interesAplicado;
    private double cuotaMensual;
    private int plazoAnos;
    private String estado;

    // 2. Constructor Vacío Obligatorio para Java Beans / Servlets
    public Prestamo() {}

    // 3. Bloque Completo de Métodos Getters y Setters
    public int getIdPrestamo() {
        return idPrestamo;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public String getDuiCliente() {
        return duiCliente;
    }

    public void setDuiCliente(String duiCliente) {
        this.duiCliente = duiCliente;
    }

    public double getMontoSolicitado() {
        return montoSolicitado;
    }

    public void setMontoSolicitado(double montoSolicitado) {
        this.montoSolicitado = montoSolicitado;
    }

    public double getInteresAplicado() {
        return interesAplicado;
    }

    public void setInteresAplicado(double interesAplicado) {
        this.interesAplicado = interesAplicado;
    }

    public double getCuotaMensual() {
        return cuotaMensual;
    }

    public void setCuotaMensual(double cuotaMensual) {
        this.cuotaMensual = cuotaMensual;
    }

    public int getPlazoAnos() {
        return plazoAnos;
    }

    public void setPlazoAnos(int plazoAnos) {
        this.plazoAnos = plazoAnos;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}