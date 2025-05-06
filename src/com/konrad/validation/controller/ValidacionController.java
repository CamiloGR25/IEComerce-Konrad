package com.konrad.validation.controller;

import com.konrad.validation.facade.ValidacionFacade;
import com.konrad.validation.models.Solicitud;
import com.konrad.validation.models.enums.EstadoSolicitud;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class ValidacionController {

    private final ValidacionFacade validacionFacade;
    private final List<Solicitud> solicitudes;

    public ValidacionController() {
        this.validacionFacade = new ValidacionFacade();
        this.solicitudes = new ArrayList<>();

        // Simulación de solicitudes pendientes en memoria
        solicitudes.add(new Solicitud("1010101010", "Luis", "Pérez", "luis.perez@mail.com"));
        solicitudes.add(new Solicitud("2020202020", "Ana", "García", "ana.garcia@mail.com"));
        solicitudes.add(new Solicitud("3030303030", "Carlos", "Rojas", "carlos.rojas@mail.com"));
    }

    public void mostrarSolicitudesPendientes() {
        System.out.println("Solicitudes PENDIENTES:");
        solicitudes.stream()
                .filter(s -> s.getEstado() == EstadoSolicitud.PENDIENTE)
                .forEach(s -> System.out.printf(" - %s | %s %s | %s | Estado: %s%n",
                        s.getNumeroIdentificacion(), s.getApellidos(), s.getNombres(), s.getCorreoElectronico(), s.getEstado()));
    }

    public void validarSolicitud() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingrese el número de identificación para validar: ");
        String id = scanner.nextLine();

        Solicitud solicitud = solicitudes.stream()
                .filter(s -> s.getNumeroIdentificacion().equals(id))
                .findFirst()
                .orElse(null);

        if (solicitud == null) {
            System.out.println("Solicitud no encontrada.");
            return;
        }

        System.out.println("\nEjecutando validación para: " + solicitud.getNombres() + " " + solicitud.getApellidos());

        EstadoSolicitud resultado = validacionFacade.validarSolicitud(solicitud);
        solicitud.actualizarEstado(resultado);

        System.out.println("Estado actualizado: " + resultado);
    }

    public void iniciar() {
        Scanner scanner = new Scanner(System.in);
        String opcion;

        do {
            System.out.println("\n=== Menú Director Comercial ===");
            System.out.println("1. Listar solicitudes pendientes");
            System.out.println("2. Validar una solicitud");
            System.out.println("0. Salir");
            System.out.print("Seleccione una opción: ");
            opcion = scanner.nextLine();

            switch (opcion) {
                case "1" -> mostrarSolicitudesPendientes();
                case "2" -> validarSolicitud();
                case "0" -> System.out.println("Cerrando sistema...");
                default -> System.out.println("Opción inválida.");
            }

        } while (!opcion.equals("0"));
    }
}
