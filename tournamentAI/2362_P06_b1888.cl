(defpackage :2362_P06_b1888 ; se declara un paquete con el grupo, la pareja y
; el código
(:use :common-lisp :conecta4) ; el paquete usa common-lisp y conecta4
(:export :heuristica :*alias*)) ; exporta la función de evaluación y un alias

(in-package 2362_P06_b1888)

(defvar *alias* '|beta|) ; alias que aparece en el ranking

(defun heuristica (estado) ; función de evaluación heurística
  
  ; current player standpoint
  (let* ((tablero (estado-tablero estado))
         (ficha-actual (estado-turno estado))
         (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
        (let ((ganador (ganador estado)))
          (cond ((not ganador) 0)
                ((eql ganador ficha-actual) +val-max+)
                (t +val-min+)))
      (let ((puntuacion-actual 0)
            (puntuacion-oponente 0))
        (loop for columna from 0 below (tablero-ancho tablero) do
          (let* ((alt (altura-columna tablero columna)))
	    (loop for altura from alt below (tablero-alto tablero) do
              (let* ((fila (1- altura))
                     (abajo (contar-abajo tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-actual columna fila))
                     (izq (contar-izquierda tablero ficha-actual columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
                (setf puntuacion-actual
                      (+ puntuacion-actual
			 (* (expt 0.20 (- altura alt))
			    (+
			       (cond ((= abajo 0) 0)
                                     ((= abajo 1) 10)
                                     ((= abajo 2) 1000)
                                     ((= abajo 3) 100000))
                               (cond ((= (+ izq der) 0) 0)
                                     ((= (+ izq der) 1) 10)
                                     ((= (+ izq der) 2) 1000)
                                     ((>= (+ izq der) 3) 100000))
                               (cond ((= (+ abajo-izq arriba-der) 0) 0)
                                     ((= (+ abajo-izq arriba-der) 1) 10)
                                     ((= (+ abajo-izq arriba-der) 2) 1000)
                                     ((>= (+ abajo-izq arriba-der) 3) 100000))
			       (cond ((= (+ abajo-der arriba-izq) 0) 0)
			             ((= (+ abajo-der arriba-izq) 1) 10)
			             ((= (+ abajo-der arriba-izq) 2) 1000)
			             ((>= (+ abajo-der arriba-izq) 3) 100000)))))))
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-oponente columna fila))
                     (der (contar-derecha tablero ficha-oponente columna fila))
                     (izq (contar-izquierda tablero ficha-oponente columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
                (setf puntuacion-oponente
                      (+ puntuacion-oponente
			 (* (expt 0.20 (- altura alt))
			    (+
                               (cond ((= abajo 0) 0)
                                     ((= abajo 1) 10)
                                     ((= abajo 2) 1000)
                                     ((= abajo 3) 100000))
                               (cond ((= (+ izq der) 0) 0)
                                     ((= (+ izq der) 1) 10)
                                     ((= (+ izq der) 2) 1000)
                                     ((>= (+ izq der) 3) 100000))
                               (cond ((= (+ abajo-izq arriba-der) 0) 0)
                                     ((= (+ abajo-izq arriba-der) 1) 10)
                                     ((= (+ abajo-izq arriba-der) 2) 1000)
                                     ((>= (+ abajo-izq arriba-der) 3) 100000))
			       (cond ((= (+ abajo-der arriba-izq) 0) 0)
			             ((= (+ abajo-der arriba-izq) 1) 10)
			             ((= (+ abajo-der arriba-izq) 2) 1000)
			             ((>= (+ abajo-der arriba-izq) 3) 100000))))))))))  
	(- puntuacion-actual puntuacion-oponente)))))

