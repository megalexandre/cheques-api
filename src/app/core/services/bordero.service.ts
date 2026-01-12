import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { BorderoPreviewRequest, BorderoPreviewResponse } from '../models/bordero.model';

@Injectable({
  providedIn: 'root'
})
export class BorderoService {

  private apiUrl = `${environment.apiUrl}/borderos/preview`;

  constructor(private http: HttpClient) { }

  calculatePreview(request: BorderoPreviewRequest): Observable<BorderoPreviewResponse> {
    return this.http.post<BorderoPreviewResponse>(this.apiUrl, request);
  }
}
