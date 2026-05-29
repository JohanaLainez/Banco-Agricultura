package com.banco.modelo;

public class Dependiente {
    private int idDependiente;
    private String duiTitular;
    private String nombre;
    private String parentesco;

    public Dependiente() {}

    public int getIdDependiente() { return idDependiente; }
    public void setIdDependiente(int idDependiente) { this.idDependiente = idDependiente; }
    public String getDuiTitular() { return duiTitular; }
    public void setDuiTitular(String duiTitular) { this.duiTitular = duiTitular; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getParentesco() { return parentesco; }
    public void setParentesco(String parentesco) { this.parentesco = parentesco; }
}