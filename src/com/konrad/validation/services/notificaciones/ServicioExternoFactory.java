package com.konrad.validation.services.notificaciones;


import com.konrad.validation.models.enums.TipoServicio;
import com.konrad.validation.ports.IServicioExterno;
import com.konrad.validation.services.adapters.CIFINAdapter;
import com.konrad.validation.services.adapters.DatacreditoAdapter;
import com.konrad.validation.services.adapters.PoliciaAdapter;

public class ServicioExternoFactory {

    private static volatile ServicioExternoFactory instance;

    private ServicioExternoFactory() {
        // Constructor privado para patrón Singleton
    }

    public static ServicioExternoFactory getInstance() {
        if (instance == null) {
            synchronized (ServicioExternoFactory.class) {
                if (instance == null) {
                    instance = new ServicioExternoFactory();
                }
            }
        }
        return instance;
    }

    @SuppressWarnings("unchecked")
    public <T> IServicioExterno<T> crearServicio(TipoServicio tipoServicio) {
        return switch (tipoServicio) {
            case DATACREDITO -> (IServicioExterno<T>) new DatacreditoAdapter();
            case CIFIN       -> (IServicioExterno<T>) new CIFINAdapter();
            case POLICIA     -> (IServicioExterno<T>) new PoliciaAdapter();
        };
    }
}
