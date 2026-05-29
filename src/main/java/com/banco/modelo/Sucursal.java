package com.banco.modelo;

public class Sucursal {
    private int idSucursal;
    private String nombreSucursal;
    private String codigoSucursal;
    private String direccion;
    private String nombreGerente;
    private double presupuestoInicial;
    private int cajasDisponibles;

    public Sucursal() {}

    // Getters y Setters
    public int getIdSucursal() { return idSucursal; }
    public void setIdSucursal(int idSucursal) { this.idSucursal = idSucursal; }

    public String getNombreSucursal() { return nombreSucursal; }
    public void setNombreSucursal(String nombreSucursal) { this.nombreSucursal = nombreSucursal; }

    public String getCodigoSucursal() { return codigoSucursal; }
    public void setCodigoSucursal(String codigoSucursal) { this.codigoSucursal = codigoSucursal; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getNombreGerente() { return nombreGerente; }
    public void setNombreGerente(String nombreGerente) { this.nombreGerente = nombreGerente; }

    public double getPresupuestoInicial() { return presupuestoInicial; }
    public void setPresupuestoInicial(double presupuestoInicial) { this.presupuestoInicial = presupuestoInicial; }

    public int getCajasDisponibles() { return cajasDisponibles; }
    public void setCajasDisponibles(int cajasDisponibles) { this.cajasDisponibles = cajasDisponibles; }
}