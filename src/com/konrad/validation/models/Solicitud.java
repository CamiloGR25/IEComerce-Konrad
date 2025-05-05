package com.konrad.validation.models;


import com.konrad.validation.models.enums.EstadoSolicitud;

public class Solicitud {

    private String numeroIdentificacion;
    private String nombres;
    private String apellidos;
    private String correoElectronico;
    private EstadoSolicitud estado;

    public Solicitud(String numeroIdentificacion, String nombres, String apellidos, String correoElectronico) {
        this.numeroIdentificacion = numeroIdentificacion;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.correoElectronico = correoElectronico;
        this.estado = EstadoSolicitud.PENDIENTE;
    }

    public String getNumeroIdentificacion() {
        return numeroIdentificacion;
    }

    public String getNombres() {
        return nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public String getCorreoElectronico() {
        return correoElectronico;
    }

    public EstadoSolicitud getEstado() {
        return estado;
    }

    public void actualizarEstado(EstadoSolicitud nuevoEstado) {
        this.estado = nuevoEstado;
    }

}
