import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.feature_selection import RFE
from sklearn.model_selection import train_test_split
import joblib
import os

def train_and_save_model():
    """
    Entrena el modelo de depresión estudiantil y lo guarda para su uso en la API
    """
    print("Cargando datos...")
    
    # Cargar el dataset procesado
    df_processed = pd.read_csv('student_depression_dataset_processed.csv')
    
    # Separar características y variable objetivo
    X = df_processed.drop('Depression', axis=1)
    y = df_processed['Depression']
    
    print("Seleccionando las mejores características...")
    
    # Crear modelo base para selección de características
    logreg = LogisticRegression(solver='liblinear', max_iter=200)
    
    # Seleccionar las 8 mejores características usando RFE
    rfe_selector = RFE(estimator=logreg, n_features_to_select=8, step=1)
    rfe_selector.fit(X, y)
    
    # Obtener características seleccionadas
    selected_features_mask = rfe_selector.support_
    selected_features = X.columns[selected_features_mask]
    X_top8 = X[selected_features]
    
    print(f"Características seleccionadas: {list(selected_features)}")
    
    # Dividir datos
    X_train, X_test, y_train, y_test = train_test_split(
        X_top8, y, test_size=0.2, random_state=42, stratify=y
    )
    
    # Identificar características numéricas para escalar
    all_possible_numeric_features = [
        'Age', 'Academic Pressure', 'CGPA', 'Work/Study Hours', 'Financial Stress'
    ]
    numeric_features_to_scale = [
        feature for feature in all_possible_numeric_features if feature in X_train.columns
    ]
    
    print(f"Características numéricas a escalar: {numeric_features_to_scale}")
    
    # Crear y ajustar el escalador
    scaler = StandardScaler()
    X_train_scaled = X_train.copy()
    X_test_scaled = X_test.copy()
    
    if numeric_features_to_scale:
        scaler.fit(X_train[numeric_features_to_scale])
        X_train_scaled[numeric_features_to_scale] = scaler.transform(X_train[numeric_features_to_scale])
        X_test_scaled[numeric_features_to_scale] = scaler.transform(X_test[numeric_features_to_scale])
    
    print("Entrenando modelo...")
    
    # Entrenar el modelo final
    final_model = LogisticRegression(solver='liblinear', random_state=42)
    final_model.fit(X_train_scaled, y_train)
    
    # Evaluar modelo
    train_score = final_model.score(X_train_scaled, y_train)
    test_score = final_model.score(X_test_scaled, y_test)
    
    print(f"Precisión en entrenamiento: {train_score:.4f}")
    print(f"Precisión en prueba: {test_score:.4f}")
    
    # Crear directorio de modelos si no existe
    os.makedirs('models', exist_ok=True)
    
    # Guardar modelo, escalador y metadatos
    joblib.dump(final_model, 'models/depression_model.pkl')
    joblib.dump(scaler, 'models/scaler.pkl')
    
    # Guardar metadatos del modelo
    model_metadata = {
        'selected_features': list(selected_features),
        'numeric_features': numeric_features_to_scale,
        'train_accuracy': train_score,
        'test_accuracy': test_score,
        'feature_names': list(X.columns)
    }
    
    joblib.dump(model_metadata, 'models/model_metadata.pkl')
    
    print("Modelo guardado exitosamente!")
    print(f"Archivos guardados en la carpeta 'models/'")
    
    return final_model, scaler, model_metadata

if __name__ == "__main__":
    train_and_save_model()
