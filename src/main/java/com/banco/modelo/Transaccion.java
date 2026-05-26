package com.banco.modelo;

public class Transaccion {
    private int idTransaccion;
    private String tipo;
    private double monto;
    private String fecha;
    private int idCuenta;

    public Transaccion() {
    }

    public Transaccion(int idTransaccion, String tipo, double monto, String fecha, int idCuenta) {
        this.idTransaccion = idTransaccion;
        this.tipo = tipo;
        this.monto = monto;
        this.fecha = fecha;
        this.idCuenta = idCuenta;
    }

    public int getIdTransaccion() {
        return idTransaccion;
    }

    public void setIdTransaccion(int idTransaccion) {
        this.idTransaccion = idTransaccion;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public int getIdCuenta() {
        return idCuenta;
    }

    public void setIdCuenta(int idCuenta) {
        this.idCuenta = idCuenta;
    }
}