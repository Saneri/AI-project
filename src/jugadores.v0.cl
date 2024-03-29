(use-package 'conecta4)
;(use-package '2362_P06_b1888)
;(use-package '2362_P06_7f738)

(declaim #+sbcl(sb-ext:muffle-conditions style-warning))

;; -------------------------------------------------------------------------------
;; Funciones de evaluación 
;; -------------------------------------------------------------------------------

(defun f-eval-alpha (estado) ; función de evaluación heurística
  
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
              (let* ((altura (altura-columna tablero columna))
                     (fila (1- altura))
                     (abajo (contar-abajo tablero ficha-actual columna fila))
                     (der (contar-derecha tablero ficha-actual columna fila))
                     (izq (contar-izquierda tablero ficha-actual columna fila))
                     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
                     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
                     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
                     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
                (setf puntuacion-actual
                      (+ puntuacion-actual
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
			       ((>= (+ abajo-der arriba-izq) 3) 100000)))))
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
                         (cond ((= abajo 0) 0)
                               ((= abajo 1) 10)
                               ((= abajo 2) 1000)
                               ((= abajo 3) 1000000))
                         (cond ((= (+ izq der) 0) 0)
                               ((= (+ izq der) 1) 10)
                               ((= (+ izq der) 2) 1000)
                               ((>= (+ izq der) 3) 1000000))
                         (cond ((= (+ abajo-izq arriba-der) 0) 0)
                               ((= (+ abajo-izq arriba-der) 1) 10)
                               ((= (+ abajo-izq arriba-der) 2) 1000)
                               ((>= (+ abajo-izq arriba-der) 3) 100000))
			 (cond ((= (+ abajo-der arriba-izq) 0) 0)
			       ((= (+ abajo-der arriba-izq) 1) 10)
			       ((= (+ abajo-der arriba-izq) 2) 1000)
			       ((>= (+ abajo-der arriba-izq) 3) 100000))))))
	(- puntuacion-actual puntuacion-oponente)))))

(defun f-eval-beta (estado) ; función de evaluación heurística
  
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




(defun f-eval-bueno (estado)
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
	      (let* ((altura (altura-columna tablero columna))
		     (fila (1- altura))
		     (abajo (contar-abajo tablero ficha-actual columna fila))
		     (der (contar-derecha tablero ficha-actual columna fila))
		     (izq (contar-izquierda tablero ficha-actual columna fila))
		     (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
		     (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
		     (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
		     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
		(setf puntuacion-actual
		      (+ puntuacion-actual
			 (cond ((= abajo 0) 0)
			       ((= abajo 1) 10)
			       ((= abajo 2) 100)
			       ((= abajo 3) 10000))
			 (cond ((= der 0) 0)
			       ((= der 1) 10)
			       ((= der 2) 100)
			       ((= der 3) 10000))
			 (cond ((= izq 0) 0)
			       ((= izq 1) 10)
			       ((= izq 2) 100)
			       ((= izq 3) 10000))
			 (cond ((= abajo-izq 0) 0)
			       ((= abajo-izq 1) 10)
			       ((= abajo-izq 2) 100)
			       ((= abajo-izq 3) 10000)))))
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
			 (cond ((= abajo 0) 0)
			       ((= abajo 1) 10)
			       ((= abajo 2) 100)
			       ((= abajo 3) 10000))
			 (cond ((= der 0) 0)
			       ((= der 1) 10)
			       ((= der 2) 100)
			       ((= der 3) 10000))
			 (cond ((= izq 0) 0)
			       ((= izq 1) 10)
			       ((= izq 2) 100)
			       ((= izq 3) 10000))
			 (cond ((= abajo-izq 0) 0)
			       ((= abajo-izq 1) 10)
			       ((= abajo-izq 2) 100)
			       ((= abajo-izq 3) 10000))))))
	(- puntuacion-actual puntuacion-oponente)))))

;; -------------------------------------------------------------------------------
;; Jugadores 
;; -------------------------------------------------------------------------------

(defvar *jugador-aleatorio* (make-jugador :nombre 'Jugador-aleatorio
					  :f-jugador #'f-jugador-aleatorio
					  :f-eval  #'f-eval-aleatoria))

(defvar *jugador-bueno* (make-jugador :nombre 'Jugador-bueno
				      :f-jugador #'f-jugador-negamax
				      :f-eval  #'f-eval-bueno))

(defvar *jugador-humano* (make-jugador :nombre 'Jugador-humano
				       :f-jugador #'f-jugador-humano
				       :f-eval  #'f-no-eval))

(defvar *jugador-alpha* (make-jugador :nombre 'jugador-test
				     :f-jugador #'f-jugador-negamax
				     :f-eval #'f-eval-alpha))

(defvar *jugador-beta* (make-jugador :nombre 'jugador-mejor
			      	      :f-jugador #'f-jugador-negamax
				      :f-eval #'f-eval-beta))

;; -------------------------------------------------------------------------------
;; Algunas partidas de ejemplo:
;; -------------------------------------------------------------------------------

(setf *verbose* t)

;(print (partida *jugador-aleatorio* *jugador-aleatorio*))
;(print (partida *jugador-aleatorio* *jugador-bueno* 4))
;(print (partida *jugador-bueno* *jugador-aleatorio* 4))
;(print (partida *jugador-bueno* *jugador-bueno* 4))
;(print (partida *jugador-humano* *jugador-humano*))
;(print (partida *jugador-humano* *jugador-aleatorio* 4))
;(print (partida *jugador-humano* *jugador-bueno* 4))
;(print (partida *jugador-aleatorio* *jugador-humano* 5))

;; ----------------------------------------
;; Nuestros algoritmos
;; ----------------------------------------

(print (partida *jugador-beta* *jugador-alpha*))

;;
