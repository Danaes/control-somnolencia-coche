with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

package body add is

   type Distance_Type is (DISTANCIA_INSEGURA, DISTANCIA_IMPRUDENTE, PELIGRO_COLISION, DISTANCIA_SEGURA);
   type Boolean is (False, True);

   procedure Background is
   begin
   loop
      null;
   end loop;
   end Background;
   

    
   protected symptom is
      pragma priority (8);
      procedure getIsTilted( value: out Boolean );
      procedure setIsTilted( value: in Boolean );
      private
         isTilted: Boolean;
   end symptom;

   protected measure is
      pragma priority (7);
      procedure getDistance( value: out Distance_Samples_Type );
      procedure setDistance( value: in Distance_Samples_Type );
      procedure getDistanceType( value: out Distance_Type );
      procedure setDistanceType( value: in Distance_Type );
      procedure getSpeed( value: out Speed_Samples_Type );
      procedure setSpeed( value: in Speed_Samples_Type );
      private
         distance: Distance_Samples_Type;
         distanceType: Distance_Type; 
         speed: Speed_Samples_Type;
   end measure;

   task headPosition is
      pragma priority (3);
   end headPosition;
   task distance is
      pragma priority (4);
   end distance;
   task display is
      pragma priority (2);
   end display;
   task risk is
      pragma priority (5);
   end risk;


   protected body symptom is
      procedure getIsTilted( value: out Boolean ) is
         begin
               value := isTilted;
      end getIsTilted;

      procedure setIsTilted( value: in Boolean )is
         begin
               isTilted := value;
      end setIsTilted;
   end symptom;

   protected body measure is
      procedure getDistance( value: out Distance_Samples_Type ) is
         begin
            value := distance;
      end getDistance;

      procedure setDistance( value: in Distance_Samples_Type )is
         begin
            distance := value;
      end setDistance;

      procedure getDistanceType( value: out Distance_Type )is
         begin
            value := distanceType;
      end getDistanceType;

      procedure setDistanceType( value: in Distance_Type )is
         begin
            distanceType := value;
      end setDistanceType;

      procedure getSpeed( value: out Speed_Samples_Type )is
         begin
            value := speed;
      end getSpeed;

      procedure setSpeed( value: in Speed_Samples_Type )is
         begin
            speed := value;
      end setSpeed;

   end measure;

   task body headPosition is
      Current_H: HeadPosition_Samples_Type := (+2,-2);
      Current_H_Ant: HeadPosition_Samples_Type := (0,0);
      Current_S: Steering_Samples_Type := 0;
      duration: Time_Span := To_time_Span(0.4);
      next_period: Time := Big_Bang + duration;
      begin
         while true loop
            Starting_Notice ("Cabeza"); 
            Reading_HeadPosition (Current_H);
            Reading_Steering (Current_S);

            if ( abs( Current_H(x) ) > 30 and abs( Current_H_Ant(x) ) > 30 ) then 
               symptom.setIsTilted( Boolean'Val(1) );
            elsif ( ( Current_H(y) > 30 and Current_H_Ant(y) > 30 and Current_S < 5) or 
               ( ( Current_H(y) < -30 and Current_H_Ant(y) < -30 and Current_S > 5) ) ) then 
               symptom.setIsTilted( Boolean'Val(1) );
            else
               symptom.setIsTilted( Boolean'Val(0) );
            end if;

            Current_H_Ant := Current_H;
            Finishing_Notice ("Cabeza");             
            delay until next_period;
            next_period := next_period + duration;
         end loop;
   end headPosition;

   task body distance is
      Current_D: Distance_Samples_Type := 0;
      Current_V: Speed_Samples_Type := 0;
      Secure_Distance: Speed_Samples_Type := 0;
      duration: Time_Span := To_time_Span(0.3);
      next_period: Time := Big_Bang + duration;
      begin
         while true loop
               Starting_Notice ("Distancia");
               Reading_Distance (Current_D);
               Reading_Speed (Current_V);

               measure.setDistance(Current_D);
               measure.setSpeed(Current_V);

               Secure_Distance := ( Current_V * Current_V) / 100;

               if ( Speed_Samples_Type(Current_D) < ( Secure_Distance / 3 ) ) then 
                  measure.setDistanceType( Distance_Type'Val (2) );
               elsif ( Speed_Samples_Type(Current_D) < ( Secure_Distance / 2 ) ) then
                  measure.setDistanceType( Distance_Type'Val (1) );
               elsif ( Speed_Samples_Type(Current_D) < Secure_Distance ) then
                  measure.setDistanceType( Distance_Type'Val (0) );
               else 
                  measure.setDistanceType( Distance_Type'Val (3) );
               end if;

               Finishing_Notice ("Distancia"); 

               delay until next_period;
               next_period := next_period + duration;
         end loop;
   end distance;

   task body display is
      isTilted: Boolean;
      distanceType: Distance_Type;
      Current_D: Distance_Samples_Type := 0;
      Current_V: Speed_Samples_Type := 0;
      duration: Time_Span := To_time_Span(1.0);
      next_period: Time := Big_Bang + duration;
      begin
         while true loop
               delay until next_period;
               next_period := next_period + duration;

               Starting_Notice ("Display");
               -- Distancia actual
               measure.getDistance(Current_D);
               Display_Distance( Current_D );
               -- End distancia

               -- Velocidad actual
               measure.getSpeed(Current_V);
               Display_Speed( Current_V );
               -- End velodidad

               -- Sintomas del conductor
               symptom.getIsTilted( isTilted );
               if( isTilted = Boolean'Val(0) ) then Starting_Notice("CONDUCTOR ATENTO");
               else Starting_Notice("CABEZA INCLINADA");
               end if;

               measure.getDistanceType( distanceType );
               Starting_Notice( Distance_Type'Image(distanceType) );
               -- End sintomas

               Finishing_Notice ("Display"); 
         end loop;
   end display;

   task body risk is
      isTilted: Boolean;
      Current_V: Speed_Samples_Type := 0;
      distanceType: Distance_Type;
      duration: Time_Span := To_time_Span(0.15);
      next_period: Time := Big_Bang + duration;
      begin
         while true loop
               delay until next_period;
               next_period := next_period + duration;
               Starting_Notice ("Riesgos");
               -- Lecturas   
               symptom.getIsTilted( isTilted );
               measure.getSpeed(Current_V);
               measure.getDistanceType( distanceType );
               -- End Lecturas

               -- Beep         
               if( ( isTilted = Boolean'Val(1) ) and ( Current_V > 70 )) then
                  Beep(2);
               elsif ( isTilted = Boolean'Val(1) ) then
                  Beep(1);
               end if;
               -- End beep

               -- Light
               case distanceType is
               when DISTANCIA_INSEGURA   => Light(On);
               when DISTANCIA_IMPRUDENTE => Light(On); Beep(3);
               when others => Light(Off);
               end case;
               -- End Light

               -- Automatic brake
               if (( distanceType = Distance_Type'Val(2) ) and ( isTilted = Boolean'Val(1) )) then
                  Beep(5);
                  Activate_Automatic_Driving;
               end if;
               -- End Automatic brake

               Finishing_Notice ("Riesgos"); 
         end loop;
   end risk;

   begin
      null;
end add;