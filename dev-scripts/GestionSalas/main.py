import tkinter as tk
from tkinter import ttk, messagebox
import requests
import random

# Requiere instalar la librería requests: pip install requests

# URL base de la Realtime Database Firebase (nodo Salas)
FIREBASE_URL = 'https://partyview-8ba30-default-rtdb.europe-west1.firebasedatabase.app/Salas'

# Lista de 20 nombres para anfitrión e invitados
NOMBRES = [
    "Ana", "Luis", "María", "Carlos", "Lucía",
    "Javier", "Elena", "Miguel", "Sofía", "Diego",
    "Laura", "Andrés", "Paula", "Daniel", "Carmen",
    "Santiago", "Isabel", "Pedro", "Marta", "José"
]

class FirebaseClient:
    def __init__(self, base_url):
        self.base_url = base_url.rstrip('/')

    def get_rooms(self):
        resp = requests.get(f"{self.base_url}.json")
        resp.raise_for_status()
        return resp.json() or {}

    def get_room(self, room_id):
        resp = requests.get(f"{self.base_url}/{room_id}.json")
        resp.raise_for_status()
        return resp.json() or {}

    def patch_room(self, room_id, patch_data):
        resp = requests.patch(f"{self.base_url}/{room_id}.json", json=patch_data)
        resp.raise_for_status()
        return resp.json()

    def delete_room(self, room_id):
        resp = requests.delete(f"{self.base_url}/{room_id}.json")
        resp.raise_for_status()
        return resp.json()

class AddRoomWindow:
    def __init__(self, master, client, refresh_cb):
        self.client = client
        self.refresh_cb = refresh_cb
        self.win = tk.Toplevel(master)
        self.win.title("Añadir Sala")

        # Campos: ID, anfitrión, IP, capacidad, estado, video
        labels = ["ID Sala", "Anfitrión", "IP Anfitrión", "Capacidad", "Estado", "Video"]
        for i, txt in enumerate(labels):
            tk.Label(self.win, text=txt).grid(row=i, column=0, pady=2)
        # Variables
        self.var_id = tk.StringVar(value=self.generate_id())
        self.var_host = tk.StringVar(value=random.choice(NOMBRES))
        self.var_ip = tk.StringVar(value=self.generate_ip())
        self.var_cap = tk.IntVar(value=random.randint(2,10))
        self.var_est = tk.StringVar(value="Abierto")
        self.var_vid = tk.BooleanVar(value=True)
        # Entradas
        tk.Entry(self.win, textvariable=self.var_id).grid(row=0, column=1)
        tk.Entry(self.win, textvariable=self.var_host).grid(row=1, column=1)
        tk.Entry(self.win, textvariable=self.var_ip).grid(row=2, column=1)
        tk.Entry(self.win, textvariable=self.var_cap).grid(row=3, column=1)
        ttk.Combobox(self.win, textvariable=self.var_est, values=["Abierto","Cerrado"], state="readonly").grid(row=4, column=1)
        tk.Checkbutton(self.win, variable=self.var_vid, text="Video").grid(row=5, column=1)
        # Botón guardar
        tk.Button(self.win, text="Crear", command=self.create).grid(row=6, columnspan=2, pady=5)

    def generate_id(self):
        return str(random.randint(10000, 99999))

    def generate_ip(self):
        return f"{random.randint(1,255)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"

    def create(self):
        room = {
            "id": self.var_id.get(),
            "anfitrion": {"nombre": self.var_host.get(), "ip": self.var_ip.get()},
            "capacidad": self.var_cap.get(),
            "estado": self.var_est.get(),
            "video": self.var_vid.get(),
            "invitados": [],
            "bloqueados": []
        }
        try:
            self.client.patch_room(self.var_id.get(), room)
            messagebox.showinfo("Éxito", "Sala creada.")
            self.refresh_cb()
            self.win.destroy()
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo crear sala:\n{e}")

class RoomManagerGUI:
    def __init__(self, root, client):
        self.client = client
        self.root = root
        root.title("Gestión de Salas")
        root.geometry("500x400")

        # Botones principales
        frame = tk.Frame(root)
        frame.pack(pady=5)
        tk.Button(frame, text="Añadir Sala", command=self.open_add_room).pack(side=tk.LEFT, padx=5)
        tk.Button(frame, text="Sala Random", command=self.create_random_room).pack(side=tk.LEFT, padx=5)
        tk.Button(frame, text="Eliminar Sala", command=self.delete_selected_room).pack(side=tk.LEFT, padx=5)

        # Lista de salas
        self.listbox = tk.Listbox(root)
        self.listbox.pack(fill=tk.BOTH, expand=True)
        self.listbox.bind('<<ListboxSelect>>', self.open_room_detail)

        self.refresh()

    def refresh(self):
        self.listbox.delete(0, tk.END)
        try:
            rooms = self.client.get_rooms()
            for rid in rooms.keys():
                self.listbox.insert(tk.END, rid)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudieron cargar las salas:{e}")

    def generate_id(self):
        return str(random.randint(10000, 99999))

    def generate_ip(self):
        return f"{random.randint(1,255)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"

    def open_add_room(self):
        AddRoomWindow(self.root, self.client, self.refresh)

    def create_random_room(self):
        rid = self.generate_id()
        room = {
            "id": rid,
            "anfitrion": {"nombre": random.choice(NOMBRES), "ip": self.generate_ip()},
            "capacidad": 5,
            "estado": "Abierto",
            "video": True,
            "invitados": [],
            "bloqueados": []
        }
        try:
            self.client.patch_room(rid, room)
            messagebox.showinfo("Éxito", f"Sala aleatoria {rid} creada.")
            self.refresh()
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo crear la sala random:{e}")

    def delete_selected_room(self):
        sel = self.listbox.curselection()
        if not sel:
            messagebox.showwarning("Eliminar", "Seleccione una sala.")
            return
        rid = self.listbox.get(sel)
        if messagebox.askyesno("Confirmar", f"Eliminar sala {rid}?"):
            try:
                self.client.delete_room(rid)
                self.refresh()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo eliminar:{e}")

    def open_room_detail(self, event):
        sel = self.listbox.curselection()
        if sel:
            rid = self.listbox.get(sel)
            RoomDetailWindow(self.client, rid, self.refresh)

from tkinter import simpledialog

class RoomDetailWindow:
    def __init__(self, client, room_id, refresh_cb):
        self.client = client
        self.room_id = room_id
        self.refresh_cb = refresh_cb
        self.win = tk.Toplevel()
        self.win.title(f"Sala {room_id}")
        self.data = self.client.get_room(room_id)

        tk.Label(self.win, text=f"Anfitrión: {self.data['anfitrion']['nombre']} ({self.data['anfitrion']['ip']})").pack(pady=3)

        tk.Label(self.win, text="Capacidad:").pack()
        self.capacidad_var = tk.IntVar(value=self.data.get("capacidad", 5))
        tk.Entry(self.win, textvariable=self.capacidad_var).pack()

        tk.Label(self.win, text="Estado:").pack()
        self.estado_var = tk.StringVar(value=self.data.get("estado","Abierto"))
        ttk.Combobox(self.win, textvariable=self.estado_var, values=["Abierto","Cerrado"], state="readonly").pack()

        self.video_var = tk.BooleanVar(value=self.data.get("video", False))
        tk.Checkbutton(self.win, text="Video habilitado", variable=self.video_var).pack()

        tk.Button(self.win, text="Guardar Cambios", command=self.save_changes).pack(pady=5)

        tk.Label(self.win, text="Invitados:").pack()
        self.inv_list = tk.Listbox(self.win)
        self.inv_list.pack(fill=tk.BOTH, expand=True)

        tk.Label(self.win, text="Bloqueados:").pack()
        self.blo_list = tk.Listbox(self.win)
        self.blo_list.pack(fill=tk.BOTH, expand=True)

        self.populate_lists()

        f = tk.Frame(self.win)
        f.pack(pady=5)
        tk.Button(f, text="Añadir Invitado", command=self.add_guest).pack(side=tk.LEFT)
        tk.Button(f, text="Random Invitado", command=self.add_random_guest).pack(side=tk.LEFT)
        tk.Button(f, text="Eliminar Usuario", command=self.del_user).pack(side=tk.LEFT)
        tk.Button(f, text="Bloquear", command=self.block_user).pack(side=tk.LEFT)
        tk.Button(f, text="Desbloquear", command=self.unblock_user).pack(side=tk.LEFT)

    def save_changes(self):
        patch = {
            "capacidad": self.capacidad_var.get(),
            "estado": self.estado_var.get(),
            "video": self.video_var.get()
        }
        self.client.patch_room(self.room_id, patch)
        messagebox.showinfo("Éxito", "Datos actualizados.")
        self.refresh_cb()

    def populate_lists(self):
        self.inv_list.delete(0, tk.END)
        self.blo_list.delete(0, tk.END)
        self.data = self.client.get_room(self.room_id)
        for u in self.data.get("invitados", []):
            self.inv_list.insert(tk.END, f"{u['nombre']} ({u['ip']})")
        for u in self.data.get("bloqueados", []):
            self.blo_list.insert(tk.END, f"{u['nombre']} ({u['ip']})")

    def add_guest(self):
        name = simpledialog.askstring("Nombre del invitado", "Introduce el nombre:")
        ip = f"{random.randint(1,255)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"
        ip = simpledialog.askstring("IP del invitado", "Modifica la IP si quieres:", initialvalue=ip)
        if name and ip:
            self.data.setdefault("invitados", []).append({"nombre": name, "ip": ip})
            self.client.patch_room(self.room_id, {"invitados": self.data["invitados"]})
            self.populate_lists()

    def add_random_guest(self):
        name = random.choice(NOMBRES)
        ip = f"{random.randint(1,255)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"
        self.data.setdefault("invitados", []).append({"nombre": name, "ip": ip})
        self.client.patch_room(self.room_id, {"invitados": self.data["invitados"]})
        self.populate_lists()

    def del_user(self):
        sel = self.inv_list.curselection() or self.blo_list.curselection()
        list_name = "invitados" if self.inv_list.curselection() else "bloqueados"
        if not sel: return
        idx = sel[0]
        self.data[list_name].pop(idx)
        self.client.patch_room(self.room_id, {list_name: self.data[list_name]})
        self.populate_lists()

    def block_user(self):
        sel = self.inv_list.curselection()
        if not sel: return
        idx = sel[0]
        u = self.data["invitados"].pop(idx)
        self.data.setdefault("bloqueados", []).append(u)
        self.client.patch_room(self.room_id, {"invitados": self.data["invitados"], "bloqueados": self.data["bloqueados"]})
        self.populate_lists()

    def unblock_user(self):
        sel = self.blo_list.curselection()
        if not sel: return
        idx = sel[0]
        u = self.data["bloqueados"].pop(idx)
        self.data.setdefault("invitados", []).append(u)
        self.client.patch_room(self.room_id, {"invitados": self.data["invitados"], "bloqueados": self.data["bloqueados"]})
        self.populate_lists()

    def generate_ip(self):
        return f"{random.randint(1,255)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"

if __name__ == '__main__':
    root = tk.Tk()
    client = FirebaseClient(FIREBASE_URL)
    app = RoomManagerGUI(root, client)
    root.mainloop()
