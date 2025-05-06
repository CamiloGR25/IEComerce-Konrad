package com.konrad.validation.ports;


public interface IServicioExterno<T> {
    T consultar(String identificacion);
}