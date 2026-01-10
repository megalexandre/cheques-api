import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { BorderoPreview, BorderoPreviewRequest, BorderoPreviewResponse } from '../models/bordero.model';

@Injectable({
  providedIn: 'root'
})
export class BorderoService {

  private apiUrl = `${environment.apiUrl}/borderos/preview`;

  constructor(private http: HttpClient) { }

  calculatePreview(request: BorderoPreviewRequest): Observable<BorderoPreview> {
    return this.http.post<BorderoPreviewResponse>(this.apiUrl, request).pipe(
      map(response => new BorderoPreview(response))
    );
  }
}
