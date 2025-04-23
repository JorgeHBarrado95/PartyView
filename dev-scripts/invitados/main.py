import requests
import json
import tkinter as tk
from tkinter import messagebox


# Definir la clase Invitado
class Invitado:
    def __init__(self, nombre, ip):
        self.nombre = nombre
        self.ip = ip

    def __str__(self):
        return f"{self.nombre} ({self.ip})"

    def to_dict(self):
        """Convertir el objeto Invitado a un diccionario para poder enviarlo a Firebase."""
        return {
            "nombre": self.nombre,
            "ip": self.ip
        }


def obtener_datos(url):
    """Función para hacer GET a la URL y obtener los datos."""
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print("Error al obtener los datos")
        return None


def actualizar_datos(url, datos):
    """Función para hacer PATCH con los datos actualizados."""
    headers = {'Content-Type': 'application/json'}
    response = requests.patch(url, data=json.dumps(datos), headers=headers)

    if response.status_code == 200:
        messagebox.showinfo("Éxito", "Datos actualizados correctamente.")
    else:
        messagebox.showerror("Error", "Error al actualizar los datos.")


def añadir_invitado(invitados, listbox, url):
    """Función para añadir un invitado."""
    nombre = entry_nombre.get()
    ip = entry_ip.get()

    if nombre and ip:
        nuevo_invitado = Invitado(nombre, ip)
        invitados.append(nuevo_invitado)
        listbox.insert(tk.END, str(nuevo_invitado))
        entry_nombre.delete(0, tk.END)
        entry_ip.delete(0, tk.END)

        # Actualizamos la base de datos con los nuevos datos
        # Primero obtenemos los datos actuales de la sala
        datos = obtener_datos(url)
        if datos:
            # Añadimos el nuevo invitado a la lista existente de invitados
            sala_invitados = datos.get('invitados', [])
            sala_invitados.append(nuevo_invitado.to_dict())

            # Actualizamos los datos en Firebase
            datos['invitados'] = sala_invitados
            actualizar_datos(url, datos)
            print(f"Invitado {nombre} añadido.")
        else:
            messagebox.showerror("Error", "No se pudieron obtener los datos de la sala.")
    else:
        messagebox.showwarning("Advertencia", "Por favor, ingresa nombre y IP.")


def eliminar_invitado(invitados, listbox, url):
    """Función para eliminar un invitado seleccionado."""
    seleccion = listbox.curselection()  # Obtener el índice del invitado seleccionado
    if seleccion:
        invitado_eliminado = listbox.get(seleccion)  # Obtener el texto del invitado seleccionado
        listbox.delete(seleccion)  # Eliminar el invitado del Listbox

        # Extraer el nombre del invitado desde la cadena (tomamos la primera palabra antes del espacio)
        nombre = invitado_eliminado.split(" ")[0]

        # Eliminar el invitado de la lista interna de invitados
        invitado_a_eliminar = None
        for invitado in invitados:
            # Ahora estamos comparando solo el nombre sin importar mayúsculas/minúsculas
            if invitado.nombre.lower() == nombre.lower():
                invitado_a_eliminar = invitado  # Encontramos al invitado a eliminar
                break  # Salir del bucle cuando lo encontramos

        # Si se encuentra el invitado en la lista, lo eliminamos
        if invitado_a_eliminar:
            invitados.remove(invitado_a_eliminar)  # Eliminarlo de la lista interna
            print(f"Invitado {nombre} eliminado.")
        else:
            print(f"No se encontró el invitado {nombre} en la lista interna.")

        # Actualizar solo los invitados restantes en la base de datos
        # Pasamos los invitados restantes a Firebase
        actualizar_datos(url, {"invitados": [invitado.to_dict() for invitado in invitados]})
    else:
        messagebox.showwarning("Advertencia", "Selecciona un invitado para eliminar.")

def actualizar_invitados(invitados, listbox):
    """Actualizar la lista de invitados en la interfaz."""
    listbox.delete(0, tk.END)  # Limpiar el Listbox
    for invitado in invitados:
        listbox.insert(tk.END, str(invitado))


def construir_url(sala_id):
    """Construir la URL a partir del ID de la sala."""
    base_url = "https://partyview-8ba30-default-rtdb.europe-west1.firebasedatabase.app/Salas/"
    return f"{base_url}{sala_id}.json"


def actualizar_sala():
    """Actualizar la sala con el ID ingresado por el usuario."""
    sala_id = entry_sala_id.get()
    if sala_id.isdigit():  # Aseguramos que el ID sea un número
        url = construir_url(sala_id)
        datos = obtener_datos(url)
        if datos:
            # Si los datos son válidos, actualizamos la lista de invitados
            invitados.clear()  # Limpiamos la lista de invitados antes de agregar los nuevos
            for invitado in datos.get('invitados', []):  # Aseguramos que existe la clave 'invitados'
                invitados.append(Invitado(invitado['nombre'], invitado['ip']))
            actualizar_invitados(invitados, listbox)
        else:
            messagebox.showerror("Error", "No se pudieron obtener los datos de la sala.")
    else:
        messagebox.showwarning("Advertencia", "Por favor, ingresa un ID de sala válido.")

# Ventana principal de gestión de invitados
root = tk.Tk()
root.title("Gestión de Invitados")
root.geometry("600x400")  # Tamaño inicial más grande
root.minsize(600, 400)  # Establece un tamaño mínimo de la ventana

# Configuración de la interfaz
tk.Label(root, text="ID de la sala:").grid(row=0, column=0, padx=10, pady=10)
entry_sala_id = tk.Entry(root, width=40)
entry_sala_id.grid(row=0, column=1, padx=10, pady=10)

# Botón para actualizar la sala
btn_actualizar_sala = tk.Button(root, text="Actualizar Sala", command=actualizar_sala)
btn_actualizar_sala.grid(row=0, column=2, padx=10, pady=10)

# Campos para añadir un nuevo invitado
tk.Label(root, text="Nombre del invitado:").grid(row=1, column=0, padx=10, pady=5)
entry_nombre = tk.Entry(root)
entry_nombre.grid(row=1, column=1, padx=10, pady=5)

tk.Label(root, text="IP del invitado:").grid(row=2, column=0, padx=10, pady=5)
entry_ip = tk.Entry(root)
entry_ip.grid(row=2, column=1, padx=10, pady=5)

# Listbox para mostrar invitados
listbox = tk.Listbox(root, height=10, width=50)
listbox.grid(row=3, column=0, columnspan=3, padx=10, pady=5)

# Llenar el Listbox con los invitados actuales cuando se carga la ventana
# Inicialmente, estará vacío hasta que se ingrese el ID de la sala y se obtengan los datos

# Botones para añadir y eliminar invitados
btn_add = tk.Button(root, text="Añadir Invitado", command=lambda: añadir_invitado([], listbox, construir_url(entry_sala_id.get())))
btn_add.grid(row=4, column=0, padx=10, pady=10)

btn_remove = tk.Button(root, text="Eliminar Invitado", command=lambda: eliminar_invitado([], listbox, construir_url(entry_sala_id.get())))
btn_remove.grid(row=4, column=1, padx=10, pady=10)

root.mainloop()
