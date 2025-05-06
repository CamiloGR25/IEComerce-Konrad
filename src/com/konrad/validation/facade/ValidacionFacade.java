package com.konrad.validation.facade;

import com.konrad.validation.models.Solicitud;
import com.konrad.validation.models.enums.CalificacionCrediticia;
import com.konrad.validation.models.enums.EstadoJudicial;
import com.konrad.validation.models.enums.EstadoSolicitud;
import com.konrad.validation.models.enums.TipoServicio;
import com.konrad.validation.ports.IServicioExterno;
import com.konrad.validation.services.notificaciones.ServicioExternoFactory;

public class ValidacionFacade {

    private final ServicioExternoFactory factory;

    public ValidacionFacade() {
        this.factory = ServicioExternoFactory.getInstance();
    }

    public EstadoSolicitud validarSolicitud(Solicitud solicitud) {
        String id = solicitud.getNumeroIdentificacion();

        // Obtener servicios externos
        IServicioExterno<CalificacionCrediticia> servicioDatacredito =
                factory.crearServicio(TipoServicio.DATACREDITO);
        IServicioExterno<CalificacionCrediticia> servicioCIFIN =
                factory.crearServicio(TipoServicio.CIFIN);
        IServicioExterno<EstadoJudicial> servicioPolicia =
                factory.crearServicio(TipoServicio.POLICIA);

        // Consultas
        CalificacionCrediticia scoreDatacredito = servicioDatacredito.consultar(id);
        CalificacionCrediticia scoreCIFIN = servicioCIFIN.consultar(id);
        EstadoJudicial estadoJudicial = servicioPolicia.consultar(id);

        // Mostrar resultados intermedios
        System.out.printf("→ Datacrédito: %s, CIFIN: %s, Policía: %s%n",
                scoreDatacredito, scoreCIFIN, estadoJudicial);

        // Regla de negocio
        if (scoreDatacredito == CalificacionCrediticia.BAJA ||
                scoreCIFIN == CalificacionCrediticia.BAJA ||
                estadoJudicial == EstadoJudicial.REQUERIDO) {
            return EstadoSolicitud.RECHAZADA;
        }

        if (scoreDatacredito == CalificacionCrediticia.ADVERTENCIA ||
                scoreCIFIN == CalificacionCrediticia.ADVERTENCIA) {
            return EstadoSolicitud.DEVUELTA;
        }

        return EstadoSolicitud.APROBADA;
    }
}