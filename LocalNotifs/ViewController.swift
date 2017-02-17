//
//  ViewController.swift
//  LocalNotifs
//
//  Created by Alejandro Fernandez Gonzalez on 16/02/2017.
//  Copyright © 2017 Alejandro Fernandez Gonzalez. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //Notificaciones Locales
        //Content
        //trigger - calendar / interval / geofence
        //id unico

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Registrar", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerLocal(){
    
        let center = UNUserNotificationCenter.current() //El que gestiona las notificaciones
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in
            if granted {
                print("Autorizacion correcta!")
            } else {
                print("Autorizacion incorrecta!")
            }
        }//Siempre antes de lanzar notificaciones hace falta comprobar la autorizacion. En options le decimos aquel tipo de notificaciones que queremos
        
    }

    
    func scheduleLocal(){
    
        let center = UNUserNotificationCenter.current()
        
        registerCategories()
        
        //Content
        let content = UNMutableNotificationContent()
        content.title = "Alarma para despertarnos!"
        content.body = "Despierta!"
        content.categoryIdentifier = "alarm" //Este idfentificador es para que cada vez que haya una notificacion de tipo alarm que lo haga
        content.userInfo = ["customData": "fizzbuz"] //user info es como un ID interno propio
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20 //EN FORMATO 24H!!
        dateComponents.minute = 12
        
        //Triguer calendario
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) //Disparador de la notificacion
        
        //Trigger Intervalo
        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
       // let trigger
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger2) //Necesita un id unico, lo logramos con uuid
        
        //Para quitar todas las notificaciones 
        //center.removeAllPendingNotificationRequets()
        center.add(request) //el completition handler lo podemos obviar. El request conecta toda la notificacion con el notification center
        
    }
    
    //UNNotificationAction PARA PODER ACCEDER A LA APLICACION DESDE LA NOTIFICACION
        //ID
        //Title
        //Optiones
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self //para poder acceder a la aplicacion desde la notificacion necesitamos un delegado. El sistema tiene que informar a la aplicacion desde fuera usamos un delegado para informar de ello
        
        //Se necesitan los dos, UNNotificationAction y UNNoitfgicationCategorie
        let show = UNNotificationAction(identifier: "show", title: "Muéstrame más", options: .foreground) //Con esto hemos creado un botoncito en la notificacion que pone muestrame mas
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: []) //Agrupa la notificacion por categorias . COge esos botones y loscoloca a una notificacion. En vez de decirle a que notificacion una por una metersleo las incluyo en una categoria
        
        center.setNotificationCategories([category])
    
    }
    
    //Este metodo nos informa cuando hemos recibido una respuesta dela notificacion
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        
        //// esto se puede omitir si no vas a hacer nada de calculos con los datos que viene
        if let customData = userInfo["customData"] as? String {
        
            print("hemos recibido: \(customData)")
            
        }
        ////
        
        
        switch response.actionIdentifier { //Actionindetifier es el indentificador de la accion.
        case UNNotificationDefaultActionIdentifier:
            //Swipe para Unlock
            print("El usuario ha deslizado la notificacion!")
            break
        case "show":
            //El usuario ha apretado nuestro botón
            print("Mostrar más informacion")
            break
        default:
            break
        }
        
        completionHandler()
    }


    
    
}

