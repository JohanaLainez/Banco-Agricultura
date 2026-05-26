package com.banco.modelo;

public class OperacionRequest {
    private String numeroCuenta;
    private double monto;

    public OperacionRequest() {
    }

    public OperacionRequest(String numeroCuenta, double monto) {
        this.numeroCuenta = numeroCuenta;
        this.monto = monto;
    }

    public String getNumeroCuenta() {
        return numeroCuenta;
    }

    public void setNumeroCuenta(String numeroCuenta) {
        this.numeroCuenta = numeroCuenta;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }
}